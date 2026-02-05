import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score, calinski_harabasz_score, davies_bouldin_score
from sklearn.decomposition import PCA
from sklearn.feature_selection import VarianceThreshold
import matplotlib.pyplot as plt
import seaborn as sns
from flask import Flask, request, jsonify
import mysql.connector
from flask_cors import CORS
from mysql.connector import Error
from contextlib import contextmanager
import traceback
import warnings
from datetime import datetime
import json
import random
warnings.filterwarnings('ignore')

app = Flask(__name__)
CORS(app)

# Configuration de la base de données
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'reco_db'
}

# Configuration des hyperparamètres optimisés
HYPERPARAMS_CONFIG = {
    'kmeans': {
        'n_init': 20,           # Augmenté pour plus de stabilité
        'max_iter': 500,        # Plus d'itérations pour convergence
        'algorithm': 'elkan',   # Plus rapide pour données denses
        'tol': 1e-5,           # Tolérance de convergence stricte
        'random_state': 42,
        'verbose': 0
    },
    'features': {
        'use_pca': True,
        'pca_variance': 0.95,   # Conserver 95% de variance
        'min_variance': 0.1,    # Éliminer features peu informatives
        'max_clusters': 20,     # Nombre maximum de clusters
        'min_cluster_size': 5   # Taille minimale des clusters
    },
    'recommendations': {
        'similarity_weight': 0.7,
        'personalization_weight': 0.3,
        'diversity_penalty': 0.2
    }
}

# Variables globales
books_df = None
ratings_df = None
users_df = None
cart_df = None
user_features = {}
book_features_matrix = None
book_id_to_index = {}
index_to_book_id = {}
book_clusters = {}
kmeans_model = None
scaler = StandardScaler()
category_encoder = LabelEncoder()
author_encoder = LabelEncoder()
data_quality_report = {}
evaluation_history = []
feature_names = []

# ============================================================================
# FONCTIONS D'ANALYSE DE DONNÉES
# ============================================================================

def analyze_data_quality():
    """Analyse la qualité des données"""
    print("🔍 Analyse de la qualité des données...")
    
    quality_report = {
        'books': {},
        'ratings': {},
        'users': {},
        'issues': []
    }
    
    # Analyse des livres
    if books_df is not None and not books_df.empty:
        quality_report['books']['total'] = len(books_df)
        quality_report['books']['missing_values'] = books_df.isnull().sum().to_dict()
        quality_report['books']['duplicates'] = books_df.duplicated(subset=['title', 'author']).sum()
        
        # Détecter les problèmes
        if 'price' in books_df.columns:
            if books_df['price'].min() <= 0:
                quality_report['issues'].append("Prix non valides (≤ 0) détectés")
        if 'stock' in books_df.columns:
            if books_df['stock'].min() < 0:
                quality_report['issues'].append("Stocks négatifs détectés")
    
    # Analyse des évaluations
    if ratings_df is not None and not ratings_df.empty:
        quality_report['ratings']['total'] = len(ratings_df)
        quality_report['ratings']['missing_values'] = ratings_df.isnull().sum().to_dict()
        quality_report['ratings']['rating_range'] = {
            'min': ratings_df['rating'].min(),
            'max': ratings_df['rating'].max(),
            'mean': ratings_df['rating'].mean()
        }
        quality_report['ratings']['unique_users'] = ratings_df['user_id'].nunique()
        quality_report['ratings']['unique_books'] = ratings_df['book_id'].nunique()
        
        # Vérifier les évaluations non valides
        invalid_ratings = ratings_df[(ratings_df['rating'] < 1) | (ratings_df['rating'] > 5)]
        if len(invalid_ratings) > 0:
            quality_report['issues'].append(f"{len(invalid_ratings)} évaluations hors plage [1,5]")
    
    # Analyse des utilisateurs
    if users_df is not None and not users_df.empty:
        quality_report['users']['total'] = len(users_df)
        quality_report['users']['missing_values'] = users_df.isnull().sum().to_dict()
    
    print(f"✅ Analyse qualité terminée: {len(quality_report['issues'])} problèmes détectés")
    return quality_report

def clean_books_data(df):
    """Nettoyage avancé des données livres"""
    print("🧹 Nettoyage des données livres...")
    
    # Copie pour éviter les warnings
    cleaned_df = df.copy()
    
    # 1. Gestion des valeurs manquantes
    if 'price' in cleaned_df.columns:
        cleaned_df['price'] = pd.to_numeric(cleaned_df['price'], errors='coerce')
        median_price = cleaned_df['price'].median()
        cleaned_df['price'] = cleaned_df['price'].fillna(median_price)
        
        # Remplacer les prix non valides
        cleaned_df.loc[cleaned_df['price'] <= 0, 'price'] = median_price
    
    if 'stock' in cleaned_df.columns:
        cleaned_df['stock'] = pd.to_numeric(cleaned_df['stock'], errors='coerce')
        median_stock = cleaned_df['stock'].median()
        cleaned_df['stock'] = cleaned_df['stock'].fillna(median_stock)
        cleaned_df.loc[cleaned_df['stock'] < 0, 'stock'] = 0
    
    # 2. Normalisation du texte
    if 'title' in cleaned_df.columns:
        cleaned_df['title'] = cleaned_df['title'].str.strip().str.title()
    
    if 'author' in cleaned_df.columns:
        cleaned_df['author'] = cleaned_df['author'].str.strip().str.title()
        
        # Encodage des auteurs
        try:
            cleaned_df['author_encoded'] = author_encoder.fit_transform(cleaned_df['author'])
        except:
            cleaned_df['author_encoded'] = 0
    
    # 3. Gestion des catégories
    if 'category_id' in cleaned_df.columns:
        # Remplacer les catégories manquantes
        mode_category = cleaned_df['category_id'].mode()[0] if not cleaned_df['category_id'].mode().empty else 1
        cleaned_df['category_id'] = cleaned_df['category_id'].fillna(mode_category)
        
        # Encodage
        cleaned_df['category_encoded'] = category_encoder.fit_transform(
            cleaned_df['category_id'].astype(str)
        )
    
    # 4. Extraction de features textuelles
    if 'title' in cleaned_df.columns:
        cleaned_df['title_length'] = cleaned_df['title'].str.len()
        cleaned_df['word_count'] = cleaned_df['title'].str.split().str.len()
    
    # 5. Features temporelles si disponible
    if 'year' in cleaned_df.columns:
        cleaned_df['year'] = pd.to_numeric(cleaned_df['year'], errors='coerce')
        current_year = datetime.now().year
        cleaned_df['age'] = current_year - cleaned_df['year'].fillna(current_year)
        cleaned_df['age'] = cleaned_df['age'].clip(lower=0, upper=100)
    
    print(f"✅ Données nettoyées: {len(cleaned_df)} livres")
    return cleaned_df

def find_optimal_clusters(features_matrix, max_clusters=20):
    """Détermine le nombre optimal de clusters avec la méthode du coude et silhouette"""
    
    if len(features_matrix) < 10:
        return max(2, min(5, len(features_matrix) // 2))
    
    silhouette_scores = []
    wcss = []  # Within-cluster sum of squares
    k_range = range(2, min(max_clusters, len(features_matrix) // 3))
    
    for k in k_range:
        # Créer une copie de la config sans n_clusters qui sera passé séparément
        config_copy = HYPERPARAMS_CONFIG['kmeans'].copy()
        # Utiliser n_init réduit pour l'optimisation (plus rapide)
        config_copy['n_init'] = 5
        
        kmeans = KMeans(
            n_clusters=k, 
            **config_copy
        )
        labels = kmeans.fit_predict(features_matrix)
        
        # Score silhouette (si plus de 1 point par cluster)
        if len(set(labels)) > 1:
            silhouette = silhouette_score(features_matrix, labels)
            silhouette_scores.append(silhouette)
        else:
            silhouette_scores.append(0)
        
        wcss.append(kmeans.inertia_)
    
    # Méthode du coude
    if len(wcss) > 2:
        wcss_diff = np.diff(wcss)
        wcss_diff_ratio = np.diff(wcss_diff) / wcss_diff[:-1]
        elbow_idx = np.argmax(wcss_diff_ratio < -0.1) + 2 if len(wcss_diff_ratio) > 0 else 2
    else:
        elbow_idx = 2
    
    # Meilleur score silhouette
    best_silhouette_idx = np.argmax(silhouette_scores) + 2
    
    # Compromis entre les deux méthodes
    optimal_k = min(elbow_idx, best_silhouette_idx)
    
    print(f"📊 Optimisation clusters: silhouette={best_silhouette_idx}, coude={elbow_idx}, final={optimal_k}")
    return optimal_k

def merge_small_clusters(labels, min_size=5):
    """Fusionne les clusters trop petits"""
    unique, counts = np.unique(labels, return_counts=True)
    
    # Identifier les petits clusters
    small_clusters = unique[counts < min_size]
    
    if len(small_clusters) > 0:
        # Trouver le cluster le plus proche pour chaque petit cluster
        for small_cluster in small_clusters:
            # Assigner au cluster majeur le plus proche
            mask = labels == small_cluster
            if np.sum(mask) > 0:
                # Trouver le cluster majeur (non petit)
                major_clusters = unique[counts >= min_size]
                if len(major_clusters) > 0:
                    nearest_cluster = major_clusters[0]
                    labels[mask] = nearest_cluster
                else:
                    # Si aucun cluster majeur, fusionner avec le plus grand
                    largest_cluster = unique[counts.argmax()]
                    labels[mask] = largest_cluster
    
    return labels

def extract_book_features_optimized():
    """Extraction de features avec sélection et pondération"""
    print("📊 Extraction de features avancées avec optimisation...")
    
    global feature_names, book_features_matrix, book_id_to_index, index_to_book_id
    
    features_list = []
    book_ids = []
    
    for _, book in books_df.iterrows():
        book_id = book['id']
        book_features = {}
        
        # 1. Features basiques (normalisées)
        book_features['price'] = float(book['price'])
        book_features['stock'] = float(book['stock'])
        book_features['category_encoded'] = float(book.get('category_encoded', 0))
        book_features['author_encoded'] = float(book.get('author_encoded', 0))
        
        # 2. Features de popularité
        if ratings_df is not None and not ratings_df.empty:
            book_ratings = ratings_df[ratings_df['book_id'] == book_id]
            rating_count = len(book_ratings)
            avg_rating = book_ratings['rating'].mean() if rating_count > 0 else 3.0
            
            book_features['avg_rating'] = float(avg_rating)
            book_features['rating_count'] = float(rating_count)
            book_features['popularity'] = float(avg_rating * np.log1p(rating_count + 1))
            
            # Variabilité des notes
            if rating_count > 1:
                rating_std = book_ratings['rating'].std()
                book_features['rating_std'] = float(rating_std)
            else:
                book_features['rating_std'] = 0.0
        else:
            book_features['avg_rating'] = 3.0
            book_features['rating_count'] = 0.0
            book_features['popularity'] = 0.0
            book_features['rating_std'] = 0.0
        
        # 3. Features textuelles
        book_features['title_length'] = float(book.get('title_length', 0))
        book_features['word_count'] = float(book.get('word_count', 0))
        
        # 4. Features temporelles
        book_features['age'] = float(book.get('age', 0))
        
        # 5. Feature de disponibilité
        book_features['available'] = float(book['stock'] > 0) if 'stock' in book else 1.0
        
        # Convertir en liste dans l'ordre fixe
        feature_names = [
            'price', 'stock', 'category_encoded', 'author_encoded',
            'avg_rating', 'rating_count', 'popularity', 'rating_std',
            'title_length', 'word_count', 'age', 'available'
        ]
        
        features_vector = [book_features.get(name, 0.0) for name in feature_names]
        
        features_list.append(features_vector)
        book_ids.append(book_id)
    
    features_matrix = np.array(features_list)
    
    # 1. Normalisation
    if len(features_list) > 1:
        features_matrix = scaler.fit_transform(features_matrix)
    
    # 2. Sélection des features par variance
    if features_matrix.shape[1] > 5 and len(features_matrix) > 10:
        selector = VarianceThreshold(threshold=HYPERPARAMS_CONFIG['features']['min_variance'])
        features_matrix = selector.fit_transform(features_matrix)
        print(f"📉 Features sélectionnées: {features_matrix.shape[1]}")
    
    # 3. Réduction de dimensionnalité PCA
    if HYPERPARAMS_CONFIG['features']['use_pca'] and features_matrix.shape[1] > 3:
        pca_variance = HYPERPARAMS_CONFIG['features']['pca_variance']
        pca = PCA(n_components=pca_variance)
        features_matrix = pca.fit_transform(features_matrix)
        print(f"📉 PCA: {features_matrix.shape[1]} composantes ({pca_variance*100}% variance)")
    
    book_features_matrix = features_matrix
    book_id_to_index = {book_id: idx for idx, book_id in enumerate(book_ids)}
    index_to_book_id = {idx: book_id for idx, book_id in enumerate(book_ids)}
    
    print(f"✅ {features_matrix.shape[1]} features extraites pour {len(book_ids)} livres")
    
    return features_matrix

# Alias pour compatibilité
extract_book_features = extract_book_features_optimized

def detect_outliers(features_matrix, threshold=3):
    """Détection des outliers"""
    print("🔎 Détection des outliers...")
    
    # Méthode simple: distance à la médiane
    median = np.median(features_matrix, axis=0)
    mad = np.median(np.abs(features_matrix - median), axis=0)
    
    # Éviter la division par zéro
    mad[mad == 0] = 1
    
    # Score Z modifié
    modified_z_scores = 0.6745 * (features_matrix - median) / mad
    
    # Identifier les outliers
    outlier_mask = np.any(np.abs(modified_z_scores) > threshold, axis=1)
    outlier_count = np.sum(outlier_mask)
    
    print(f"✅ {outlier_count} outliers détectés ({outlier_count/len(features_matrix):.1%})")
    
    return outlier_mask, outlier_count

# ============================================================================
# FONCTIONS D'ÉVALUATION
# ============================================================================

def evaluate_clustering(features_matrix, labels, model_name="K-Means"):
    """Évalue la qualité du clustering"""
    print(f"📈 Évaluation du clustering {model_name}...")
    
    if len(np.unique(labels)) < 2:
        print("⚠️ Pas assez de clusters pour l'évaluation")
        return {}
    
    metrics = {}
    
    try:
        # 1. Silhouette Score (-1 à 1, plus haut = mieux)
        silhouette = silhouette_score(features_matrix, labels)
        metrics['silhouette_score'] = float(silhouette)
        
        # 2. Calinski-Harabasz Index (plus haut = mieux)
        calinski = calinski_harabasz_score(features_matrix, labels)
        metrics['calinski_harabasz'] = float(calinski)
        
        # 3. Davies-Bouldin Index (plus bas = mieux)
        davies = davies_bouldin_score(features_matrix, labels)
        metrics['davies_bouldin'] = float(davies)
        
        # 4. Distribution des clusters
        unique, counts = np.unique(labels, return_counts=True)
        metrics['cluster_distribution'] = dict(zip(map(int, unique), map(int, counts)))
        metrics['n_clusters'] = int(len(unique))
        
        # 5. Taille des clusters
        metrics['cluster_sizes'] = {
            'min': int(np.min(counts)),
            'max': int(np.max(counts)),
            'mean': float(np.mean(counts)),
            'std': float(np.std(counts))
        }
        
        # 6. Coherence intra-cluster
        intra_cluster_distances = []
        for cluster_id in unique:
            cluster_points = features_matrix[labels == cluster_id]
            if len(cluster_points) > 1:
                centroid = np.mean(cluster_points, axis=0)
                distances = np.linalg.norm(cluster_points - centroid, axis=1)
                intra_cluster_distances.extend(distances)
        
        if intra_cluster_distances:
            metrics['intra_cluster_distance'] = {
                'mean': float(np.mean(intra_cluster_distances)),
                'std': float(np.std(intra_cluster_distances))
            }
        
        # Interprétation
        interpretations = []
        
        if silhouette > 0.7:
            interpretations.append("Clusters bien séparés et denses")
        elif silhouette > 0.5:
            interpretations.append("Clusters raisonnablement séparés")
        elif silhouette > 0.25:
            interpretations.append("Clusters faibles, certains points mal assignés")
        else:
            interpretations.append("Clusters peu définis")
        
        if davies < 0.5:
            interpretations.append("Faible chevauchement entre clusters")
        elif davies < 1.0:
            interpretations.append("Chevauchement modéré entre clusters")
        else:
            interpretations.append("Fort chevauchement entre clusters")
        
        metrics['interpretation'] = interpretations
        
        print(f"✅ Évaluation terminée:")
        print(f"   Silhouette: {silhouette:.3f}")
        print(f"   Calinski-Harabasz: {calinski:.1f}")
        print(f"   Davies-Bouldin: {davies:.3f}")
        print(f"   {len(unique)} clusters, taille moyenne: {np.mean(counts):.1f}")
        
        # Stocker dans l'historique
        evaluation_history.append({
            'timestamp': datetime.now().isoformat(),
            'type': 'clustering',
            'metrics': metrics
        })
        
    except Exception as e:
        print(f"❌ Erreur évaluation clustering: {e}")
        metrics['error'] = str(e)
    
    return metrics

def evaluate_recommendations(recommendations, user_history=None, all_books=None):
    """Évalue la qualité des recommandations"""
    print("🎯 Évaluation des recommandations...")
    
    if not recommendations:
        return {
            'coverage': 0,
            'diversity': 0,
            'novelty': 0,
            'serendipity': 0
        }
    
    metrics = {}
    
    # 1. Couverture (nombre unique de livres recommandés / total livres)
    if all_books is not None:
        recommended_ids = [r['id'] for r in recommendations if isinstance(r, dict) and 'id' in r]
        unique_recommended = set(recommended_ids)
        metrics['coverage'] = len(unique_recommended) / len(all_books) if len(all_books) > 0 else 0
        metrics['unique_recommended'] = len(unique_recommended)
        metrics['total_books'] = len(all_books)
    
    # 2. Diversité (basée sur les catégories)
    categories = []
    authors = []
    for rec in recommendations:
        if isinstance(rec, dict):
            if 'category_id' in rec:
                categories.append(rec['category_id'])
            if 'author' in rec:
                authors.append(rec['author'])
    
    if categories:
        metrics['category_diversity'] = len(set(categories)) / len(categories) if categories else 0
    if authors:
        metrics['author_diversity'] = len(set(authors)) / len(authors) if authors else 0
    
    # 3. Nouveauté (recommandations non vues par l'utilisateur)
    if user_history is not None:
        user_book_ids = set(user_history.get('evaluated_books', []))
        new_recommendations = [r for r in recommendations 
                             if isinstance(r, dict) and r.get('id') not in user_book_ids]
        metrics['novelty'] = len(new_recommendations) / len(recommendations) if recommendations else 0
    
    # 4. Score moyen
    if recommendations and 'score' in recommendations[0]:
        scores = [r.get('score', 0) for r in recommendations]
        metrics['score_distribution'] = {
            'min': float(np.min(scores)),
            'max': float(np.max(scores)),
            'mean': float(np.mean(scores)),
            'std': float(np.std(scores))
        }
    
    return metrics

def generate_evaluation_report(clustering_metrics=None, recommendation_metrics=None):
    """Génère un rapport d'évaluation"""
    print("📋 Génération du rapport d'évaluation...")
    
    report = {
        'timestamp': datetime.now().isoformat(),
        'clustering': clustering_metrics or {},
        'recommendations': recommendation_metrics or {},
        'summary': {},
        'data_quality': data_quality_report
    }
    
    # Résumé clustering
    if clustering_metrics:
        report['summary']['clustering'] = {
            'n_clusters': clustering_metrics.get('n_clusters', 0),
            'silhouette_score': clustering_metrics.get('silhouette_score', 0),
            'quality': clustering_metrics.get('interpretation', ['Non évalué'])[0] if clustering_metrics.get('interpretation') else 'Non évalué'
        }
    
    # Résumé recommandations
    if recommendation_metrics:
        report['summary']['recommendations'] = {
            'coverage': recommendation_metrics.get('coverage', 0),
            'diversity': recommendation_metrics.get('category_diversity', 0),
            'novelty': recommendation_metrics.get('novelty', 0)
        }
    
    # Stocker dans l'historique
    evaluation_history.append({
        'timestamp': datetime.now().isoformat(),
        'type': 'full_report',
        'report': report
    })
    
    return report

def visualize_clusters(features_matrix, labels, save_path="clusters_visualization.png"):
    """Visualisation 2D des clusters"""
    try:
        if features_matrix.shape[1] > 2:
            # Réduction à 2D avec PCA
            pca = PCA(n_components=2)
            reduced_data = pca.fit_transform(features_matrix)
        else:
            reduced_data = features_matrix
        
        plt.figure(figsize=(10, 8))
        
        # Scatter plot
        unique_labels = np.unique(labels)
        colors = plt.cm.Set3(np.linspace(0, 1, len(unique_labels)))
        
        for i, label in enumerate(unique_labels):
            cluster_points = reduced_data[labels == label]
            plt.scatter(cluster_points[:, 0], cluster_points[:, 1],
                      color=colors[i], label=f'Cluster {label}', alpha=0.7)
        
        plt.title('Visualisation des Clusters K-Means')
        plt.xlabel('Composante principale 1')
        plt.ylabel('Composante principale 2')
        plt.legend()
        plt.grid(True, alpha=0.3)
        
        plt.savefig(save_path, dpi=150, bbox_inches='tight')
        print(f"✅ Visualisation sauvegardée: {save_path}")
        
        plt.close()
        
        return True
        
    except Exception as e:
        print(f"❌ Erreur visualisation: {e}")
        return False

# ============================================================================
# FONCTIONS DE BASE DE DONNÉES
# ============================================================================

@contextmanager
def get_connection():
    """Gestionnaire de connexion à la base de données"""
    connection = None
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        yield connection
    except Error as e:
        print(f"❌ Erreur connexion MySQL: {e}")
        raise
    finally:
        if connection and connection.is_connected():
            connection.close()

def load_data_from_db():
    """Charge les données depuis la base MySQL"""
    global books_df, ratings_df, users_df, cart_df, data_quality_report
    
    try:
        print("📊 Chargement des données depuis MySQL...")
        
        with get_connection() as conn:
            cursor = conn.cursor(dictionary=True)
            
            # 1. Charger les livres
            cursor.execute("""
                SELECT b.*, c.name as category_name 
                FROM books b 
                LEFT JOIN categories c ON b.category_id = c.id
            """)
            books = cursor.fetchall()
            books_df = pd.DataFrame(books)
            
            # 2. Charger les évaluations
            cursor.execute("SELECT user_id, book_id, rating FROM ratings")
            ratings = cursor.fetchall()
            ratings_df = pd.DataFrame(ratings) if ratings else pd.DataFrame(columns=['user_id', 'book_id', 'rating'])
            
            # 3. Charger les utilisateurs
            cursor.execute("SELECT id, username FROM users")
            users = cursor.fetchall()
            users_df = pd.DataFrame(users) if users else pd.DataFrame(columns=['id', 'username'])
            
            # 4. Charger le panier
            cursor.execute("SELECT user_id, book_id FROM cart")
            cart = cursor.fetchall()
            cart_df = pd.DataFrame(cart) if cart else pd.DataFrame(columns=['user_id', 'book_id'])
            
            print(f"✅ Données brutes chargées: {len(books_df)} livres, {len(users_df)} utilisateurs, {len(ratings_df)} évaluations")
            
            # Analyse de la qualité des données
            data_quality_report = analyze_data_quality()
            
            # Prétraitement des données
            if len(books_df) > 0:
                books_df = clean_books_data(books_df)
                extract_book_features()
                train_kmeans_model_optimized()
                prepare_user_profiles()
            else:
                print("⚠️ Pas de livres dans la base de données")
                
    except Exception as e:
        print(f"❌ Erreur chargement données: {e}")
        traceback.print_exc()

# ============================================================================
# FONCTIONS DU MODÈLE K-MEANS OPTIMISÉ
# ============================================================================

def train_kmeans_model_optimized(config=None):
    """Entraîne le modèle K-Means avec optimisation des hyperparamètres"""
    global kmeans_model, book_clusters, book_features_matrix
    
    if book_features_matrix is None or len(book_features_matrix) < 2:
        print("❌ Pas assez de données pour K-Means")
        return False
    
    print("🤖 Entraînement du modèle K-Means optimisé...")
    
    # Utiliser la configuration par défaut ou celle fournie
    if config is None:
        config = HYPERPARAMS_CONFIG['kmeans'].copy()
    else:
        config = config.copy()
    
    # Trouver le nombre optimal de clusters
    n_clusters = find_optimal_clusters(
        book_features_matrix, 
        max_clusters=HYPERPARAMS_CONFIG['features']['max_clusters']
    )
    
    print(f"📊 Utilisation de {n_clusters} clusters pour {len(book_features_matrix)} livres")
    
    # Ajouter n_clusters à la configuration
    config['n_clusters'] = n_clusters
    
    # Créer le modèle avec les hyperparamètres optimisés
    kmeans_model = KMeans(**config)
    
    # Assigner les clusters
    clusters = kmeans_model.fit_predict(book_features_matrix)
    
    # Post-processing: fusionner les petits clusters
    min_cluster_size = HYPERPARAMS_CONFIG['features']['min_cluster_size']
    clusters = merge_small_clusters(clusters, min_size=min_cluster_size)
    
    # Stocker les clusters par livre
    book_clusters = {}
    for idx, cluster_id in enumerate(clusters):
        book_id = index_to_book_id[idx]
        book_clusters[book_id] = int(cluster_id)
    
    # Évaluer le clustering
    clustering_metrics = evaluate_clustering(book_features_matrix, clusters)
    
    # Visualiser les clusters
    visualize_clusters(book_features_matrix, clusters)
    
    # Afficher la distribution
    cluster_counts = np.bincount(clusters)
    print(f"✅ K-Means entraîné avec {len(np.unique(clusters))} clusters")
    print(f"📊 Métriques: Silhouette={clustering_metrics.get('silhouette_score', 0):.3f}")
    for i, count in enumerate(cluster_counts):
        print(f"   Cluster {i}: {count} livres")
    
    return True

# Alias pour compatibilité
train_kmeans_model = train_kmeans_model_optimized

def evaluate_multiple_configs(features_matrix, configs_list):
    """Évalue plusieurs configurations d'hyperparamètres"""
    results = []
    
    for i, config in enumerate(configs_list):
        print(f"🔧 Test configuration {i+1}/{len(configs_list)}: {config}")
        
        try:
            # S'assurer que n_clusters est présent
            if 'n_clusters' not in config:
                n_books = len(features_matrix)
                config['n_clusters'] = min(10, n_books // 5)
            
            kmeans = KMeans(**config)
            labels = kmeans.fit_predict(features_matrix)
            
            # Évaluation
            if len(np.unique(labels)) > 1:
                silhouette = silhouette_score(features_matrix, labels)
                davies = davies_bouldin_score(features_matrix, labels)
                
                results.append({
                    'config_id': i,
                    'config': config,
                    'silhouette': float(silhouette),
                    'davies_bouldin': float(davies),
                    'inertia': float(kmeans.inertia_),
                    'n_clusters': int(len(np.unique(labels))),
                    'cluster_sizes': dict(zip(*np.unique(labels, return_counts=True)))
                })
                
                print(f"   Silhouette: {silhouette:.3f}, Davies-Bouldin: {davies:.3f}")
                
        except Exception as e:
            print(f"   ❌ Erreur: {e}")
    
    # Trier par score silhouette (descendant)
    if results:
        results.sort(key=lambda x: x['silhouette'], reverse=True)
    
    return results

def get_recommended_config(data_size):
    """Retourne la configuration recommandée basée sur la taille des données"""
    
    if data_size < 100:
        return {
            'n_clusters': min(5, data_size // 3),
            'n_init': 10,
            'max_iter': 200,
            'algorithm': 'full',
            'tol': 1e-4,
            'random_state': 42
        }
    elif data_size < 1000:
        return {
            'n_clusters': int(np.sqrt(data_size)),
            'n_init': 15,
            'max_iter': 300,
            'algorithm': 'elkan',
            'tol': 1e-4,
            'random_state': 42
        }
    else:
        return {
            'n_clusters': min(20, data_size // 50),
            'n_init': 20,
            'max_iter': 500,
            'algorithm': 'auto',
            'tol': 1e-5,
            'random_state': 42
        }

# ============================================================================
# FONCTIONS DE PROFIL UTILISATEUR
# ============================================================================

def prepare_user_profiles():
    """Prépare les profils utilisateurs depuis la base de données"""
    global user_features
    
    print("👤 Préparation des profils utilisateurs...")
    
    try:
        with get_connection() as conn:
            cursor = conn.cursor(dictionary=True)
            
            # Récupérer tous les utilisateurs
            cursor.execute("SELECT id FROM users")
            users = cursor.fetchall()
            
            for user in users:
                user_id = user['id']
                
                # Récupérer les évaluations de l'utilisateur
                cursor.execute("""
                    SELECT r.book_id, r.rating, b.category_id, b.author, b.price
                    FROM ratings r
                    JOIN books b ON r.book_id = b.id
                    WHERE r.user_id = %s
                """, (user_id,))
                ratings = cursor.fetchall()
                
                if len(ratings) >= 1:
                    ratings_df_local = pd.DataFrame(ratings)
                    
                    # Calcul des préférences
                    avg_rating = ratings_df_local['rating'].mean()
                    
                    # Catégories préférées
                    category_prefs = {}
                    for _, row in ratings_df_local.iterrows():
                        cat = row['category_id']
                        rating_val = row['rating']
                        category_prefs[cat] = category_prefs.get(cat, 0) + rating_val
                    
                    # Auteurs préférés
                    author_prefs = {}
                    for _, row in ratings_df_local.iterrows():
                        author = row['author']
                        rating_val = row['rating']
                        author_prefs[author] = author_prefs.get(author, 0) + rating_val
                    
                    # Plage de prix préférée
                    if not ratings_df_local.empty:
                        avg_price = ratings_df_local['price'].mean()
                        price_range = (max(0, avg_price * 0.5), avg_price * 1.5)
                    else:
                        price_range = (0, 100)
                    
                    user_features[user_id] = {
                        'avg_rating': float(avg_rating),
                        'category_prefs': dict(sorted(category_prefs.items(), key=lambda x: x[1], reverse=True)[:5]),
                        'author_prefs': dict(sorted(author_prefs.items(), key=lambda x: x[1], reverse=True)[:10]),
                        'preferred_price_range': price_range,
                        'total_ratings': len(ratings),
                        'last_updated': datetime.now().isoformat()
                    }
            
            print(f"✅ Profils créés pour {len(user_features)} utilisateurs")
            
    except Exception as e:
        print(f"❌ Erreur préparation profils: {e}")
        traceback.print_exc()

def recalculate_user_profile(user_id):
    """Recalcule le profil utilisateur"""
    global user_features
    
    try:
        with get_connection() as conn:
            cursor = conn.cursor(dictionary=True)
            cursor.execute("""
                SELECT r.book_id, r.rating, b.category_id, b.author, b.price
                FROM ratings r
                JOIN books b ON r.book_id = b.id
                WHERE r.user_id = %s
            """, (user_id,))
            ratings = cursor.fetchall()
            
            if ratings:
                ratings_df_local = pd.DataFrame(ratings)
                avg_rating = ratings_df_local['rating'].mean()
                
                category_prefs = {}
                author_prefs = {}
                
                for _, row in ratings_df_local.iterrows():
                    cat = row['category_id']
                    rating_val = row['rating']
                    category_prefs[cat] = category_prefs.get(cat, 0) + rating_val
                    
                    author = row['author']
                    author_prefs[author] = author_prefs.get(author, 0) + rating_val
                
                good_ratings = ratings_df_local[ratings_df_local['rating'] >= 4]
                if not good_ratings.empty:
                    avg_price = good_ratings['price'].mean()
                    price_range = (max(0, avg_price * 0.5), avg_price * 1.5)
                else:
                    price_range = (0, 100)
                
                user_features[user_id] = {
                    'avg_rating': float(avg_rating),
                    'category_prefs': dict(sorted(category_prefs.items(), key=lambda x: x[1], reverse=True)[:5]),
                    'author_prefs': dict(sorted(author_prefs.items(), key=lambda x: x[1], reverse=True)[:10]),
                    'preferred_price_range': price_range,
                    'total_ratings': len(ratings),
                    'last_updated': datetime.now().isoformat()
                }
                
                print(f"✅ Profil {user_id} recalculé: {len(ratings)} évaluations")
            else:
                # Profil par défaut
                user_features[user_id] = {
                    'avg_rating': 3.0,
                    'category_prefs': {},
                    'author_prefs': {},
                    'preferred_price_range': (0, 100),
                    'total_ratings': 0,
                    'last_updated': datetime.now().isoformat()
                }
                
    except Exception as e:
        print(f"❌ Erreur recalcul profil {user_id}: {e}")

def get_user_profile(user_id):
    """Récupère le profil utilisateur"""
    if user_id in user_features:
        return user_features[user_id]
    
    recalculate_user_profile(user_id)
    
    if user_id in user_features:
        return user_features[user_id]
    
    return {
        'user_id': user_id,
        'avg_rating': 3.0,
        'category_prefs': {},
        'author_prefs': {},
        'preferred_price_range': (0, 100),
        'total_ratings': 0,
        'last_updated': datetime.now().isoformat()
    }

# ============================================================================
# FONCTIONS DE RECOMMANDATION OPTIMISÉES
# ============================================================================

def get_recommendations(book_id, user_id=None, n_recommendations=8):
    """Recommandations pour un livre avec clustering K-Means"""
    if not kmeans_model or book_id not in book_clusters:
        print(f"❌ K-Means non entraîné ou livre {book_id} non trouvé")
        return []
    
    try:
        # Trouver le cluster du livre
        book_cluster = book_clusters[book_id]
        
        # Trouver tous les livres du même cluster
        cluster_book_ids = []
        for bid, cid in book_clusters.items():
            if cid == book_cluster and bid != book_id:
                cluster_book_ids.append(bid)
        
        print(f"🔍 Livre {book_id} dans le cluster {book_cluster} - {len(cluster_book_ids)} livres similaires")
        
        # Si pas assez de livres dans le cluster, chercher dans les clusters similaires
        if len(cluster_book_ids) < n_recommendations:
            print(f"⚠️ Pas assez de livres dans le cluster {book_cluster}, recherche étendue...")
            
            # Calculer la distance aux autres clusters
            book_idx = book_id_to_index[book_id]
            book_vector = book_features_matrix[book_idx].reshape(1, -1)
            
            # Trouver les distances aux centroïdes
            distances = kmeans_model.transform(book_vector)[0]
            
            # Trier les clusters par distance
            sorted_clusters = np.argsort(distances)
            
            # Prendre des livres des clusters les plus proches
            additional_books = []
            for cluster in sorted_clusters:
                if cluster == book_cluster or len(additional_books) >= n_recommendations:
                    continue
                
                # Trouver les livres de ce cluster
                cluster_books = [bid for bid, cid in book_clusters.items() if cid == cluster and bid != book_id]
                
                # Prendre quelques livres de ce cluster
                take_count = min(2, len(cluster_books))
                if take_count > 0:
                    selected = random.sample(cluster_books, take_count)
                    additional_books.extend(selected)
            
            cluster_book_ids.extend(additional_books)
        
        # Limiter le nombre de livres
        cluster_book_ids = cluster_book_ids[:n_recommendations * 3]
        
        recommendations = []
        for rec_book_id in cluster_book_ids:
            book_data = books_df[books_df['id'] == rec_book_id].iloc[0]
            
            # Calculer la similarité
            same_cluster = book_clusters[rec_book_id] == book_cluster
            similarity = 0.9 if same_cluster else 0.6
            
            personalization_score = 0
            reason = f"Cluster similaire ({book_cluster})"
            
            if user_id and user_id in user_features:
                profile = user_features[user_id]
                
                if book_data['category_id'] in profile['category_prefs']:
                    personalization_score += profile['category_prefs'][book_data['category_id']] * 0.3
                    reason = "Catégorie préférée dans votre cluster"
                
                if book_data['author'] in profile['author_prefs']:
                    personalization_score += profile['author_prefs'][book_data['author']] * 0.5
                    reason = "Auteur que vous appréciez"
                
                min_price, max_price = profile['preferred_price_range']
                if min_price <= book_data['price'] <= max_price:
                    personalization_score += 0.2
            
            # Utiliser les poids de la configuration
            similarity_weight = HYPERPARAMS_CONFIG['recommendations']['similarity_weight']
            personalization_weight = HYPERPARAMS_CONFIG['recommendations']['personalization_weight']
            
            final_score = similarity * similarity_weight + personalization_score * personalization_weight
            
            recommendations.append({
                'id': int(rec_book_id),
                'title': str(book_data['title']),
                'author': str(book_data['author']),
                'category_id': int(book_data['category_id']),
                'price': float(book_data['price']),
                'image_url': str(book_data.get('image_url', f'https://via.placeholder.com/220x300?text={book_data["title"]}')),
                'similarity': similarity,
                'personalization_score': personalization_score,
                'final_score': final_score,
                'cluster_id': int(book_clusters[rec_book_id]),
                'reason': reason
            })
        
        recommendations.sort(key=lambda x: x['final_score'], reverse=True)
        return recommendations[:n_recommendations]
        
    except Exception as e:
        print(f"❌ Erreur recommandations K-Means: {e}")
        traceback.print_exc()
        return []

def get_intelligent_recommendations(user_id, n_recommendations=12):
    """Recommandations intelligentes basées sur les préférences utilisateur"""
    try:
        print(f"🎯 Début recommandations intelligentes pour user {user_id}")
        
        # Recharger les données à jour
        load_data_from_db()
        
        if books_df is None or books_df.empty:
            print("❌ Pas de livres dans la base")
            return get_enhanced_fallback_recommendations()
        
        print(f"📚 {len(books_df)} livres disponibles dans {len(set(book_clusters.values()))} clusters")
        
        # Recalculer le profil
        recalculate_user_profile(user_id)
        
        # Récupérer le profil
        profile = get_user_profile(user_id)
        
        total_ratings = profile.get('total_ratings', 0)
        print(f"📊 Profil user {user_id}: {total_ratings} évaluations")
        
        # Analyser les clusters préférés de l'utilisateur
        user_cluster_prefs = {}
        if total_ratings > 0 and ratings_df is not None:
            user_ratings = ratings_df[ratings_df['user_id'] == user_id]
            for _, rating_row in user_ratings.iterrows():
                book_id = rating_row['book_id']
                if book_id in book_clusters:
                    cluster_id = book_clusters[book_id]
                    rating = rating_row['rating']
                    user_cluster_prefs[cluster_id] = user_cluster_prefs.get(cluster_id, 0) + rating
        
        # Trouver les clusters préférés
        preferred_clusters = []
        if user_cluster_prefs:
            sorted_clusters = sorted(user_cluster_prefs.items(), key=lambda x: x[1], reverse=True)
            preferred_clusters = [cluster_id for cluster_id, _ in sorted_clusters[:3]]
            print(f"🎯 Clusters préférés: {preferred_clusters}")
        
        # TOUJOURS inclure des livres
        print("⚠️ Stratégie: Inclure TOUS les livres (même évalués) avec scores ajustés")
        
        recommended_books = []
        books_processed = 0
        
        # Livres évalués par l'utilisateur
        user_evaluated_books = set()
        if ratings_df is not None and not ratings_df.empty:
            user_ratings_data = ratings_df[ratings_df['user_id'] == user_id]
            user_evaluated_books = set(user_ratings_data['book_id'].tolist())
        
        print(f"📖 Livres évalués par user {user_id}: {len(user_evaluated_books)}")
        
        # Parcourir TOUS les livres
        for _, book in books_df.iterrows():
            books_processed += 1
            score = 0
            reasons = []
            
            # Vérifier si l'utilisateur a déjà évalué ce livre
            is_evaluated = book['id'] in user_evaluated_books
            
            # Récupérer la note de l'utilisateur pour ce livre
            user_rating = None
            if is_evaluated and ratings_df is not None:
                user_ratings = ratings_df[
                    (ratings_df['user_id'] == user_id) & 
                    (ratings_df['book_id'] == book['id'])
                ]
                if not user_ratings.empty:
                    user_rating = user_ratings.iloc[0]['rating']
            
            # Score de cluster (30%)
            if book['id'] in book_clusters:
                cluster_id = book_clusters[book['id']]
                if cluster_id in preferred_clusters:
                    cluster_score = user_cluster_prefs.get(cluster_id, 1) * 0.3
                    score += cluster_score
                    reasons.append(f"Cluster préféré ({cluster_id})")
                else:
                    score += 0.1 * 0.3
            
            # Score de catégorie (20%)
            if 'category_prefs' in profile and book['category_id'] in profile['category_prefs']:
                cat_score = profile['category_prefs'][book['category_id']]
                if is_evaluated and user_rating:
                    if user_rating >= 4:
                        cat_score = cat_score * 1.2
                        reasons.append(f"Catégorie préférée (vous avez noté {user_rating}/5)")
                    elif user_rating <= 2:
                        cat_score = cat_score * 0.3
                    else:
                        cat_score = cat_score * 0.7
                else:
                    reasons.append("Catégorie préférée")
                
                score += cat_score * 0.2
            
            # Score d'auteur (20%)
            if 'author_prefs' in profile and book['author'] in profile['author_prefs']:
                author_score = profile['author_prefs'][book['author']]
                if is_evaluated and user_rating:
                    if user_rating >= 4:
                        author_score = author_score * 1.3
                        reasons.append(f"Auteur apprécié (vous avez noté {user_rating}/5)")
                    elif user_rating <= 2:
                        author_score = author_score * 0.2
                    else:
                        author_score = author_score * 0.6
                else:
                    reasons.append("Auteur apprécié")
                
                score += author_score * 0.2
            
            # Score de prix (10%)
            if 'preferred_price_range' in profile:
                min_price, max_price = profile['preferred_price_range']
                if min_price <= book['price'] <= max_price:
                    score += 0.1
                    reasons.append("Budget adapté")
            
            # Score de popularité globale (10%)
            if ratings_df is not None and not ratings_df.empty:
                book_ratings = ratings_df[ratings_df['book_id'] == book['id']]
                if not book_ratings.empty:
                    avg_book_rating = book_ratings['rating'].mean()
                    rating_count = len(book_ratings)
                    popularity_score = avg_book_rating * np.log1p(rating_count + 1)
                    score += popularity_score * 0.1
                    if avg_book_rating >= 4.0:
                        reasons.append(f"Note: {avg_book_rating:.1f}/5")
            
            # Score de nouveauté (10%)
            novelty_score = 0.1 * (books_processed % 10) / 10
            score += novelty_score
            
            # Score minimal pour TOUS les livres
            base_score = 0.05
            score += base_score
            
            # Récupérer les notes moyennes
            avg_book_rating_val = 3.0
            rating_count_val = 0
            if ratings_df is not None and not ratings_df.empty:
                book_ratings = ratings_df[ratings_df['book_id'] == book['id']]
                if not book_ratings.empty:
                    avg_book_rating_val = book_ratings['rating'].mean()
                    rating_count_val = len(book_ratings)
            
            recommended_books.append({
                'id': int(book['id']),
                'title': str(book['title']),
                'author': str(book['author']),
                'score': float(score),
                'reasons': reasons,
                'category_id': int(book['category_id']),
                'price': float(book['price']),
                'image_url': book.get('image_url', f'https://via.placeholder.com/220x300?text={book["title"]}'),
                'is_evaluated': is_evaluated,
                'user_rating': float(user_rating) if user_rating else None,
                'avg_rating': float(avg_book_rating_val),
                'rating_count': int(rating_count_val)
            })
        
        print(f"📚 {len(recommended_books)} livres évalués pour recommandation")
        
        # Trier par score
        recommended_books.sort(key=lambda x: x['score'], reverse=True)
        
        # Appliquer diversité intelligente
        final_recommendations = []
        categories_used = set()
        authors_used = set()
        clusters_used = set()
        
        # Mélanger livres évalués et non évalués
        evaluated_included = 0
        non_evaluated_included = 0
        
        for book in recommended_books:
            if len(final_recommendations) >= n_recommendations:
                break
            
            # Critères de diversité
            category_ok = (len(categories_used) < 4 or book['category_id'] not in categories_used)
            author_ok = (len(authors_used) < 6 or book['author'] not in authors_used)
            
            # Vérifier le cluster
            cluster_id = book_clusters.get(book['id'])
            cluster_ok = True
            if cluster_id is not None:
                cluster_books = [b for b in final_recommendations if book_clusters.get(b['id']) == cluster_id]
                if len(cluster_books) >= 3:
                    cluster_ok = False
            
            if (category_ok or author_ok) and cluster_ok:
                # Générer une raison personnalisée
                if book['is_evaluated']:
                    if book['user_rating']:
                        if book['user_rating'] >= 4:
                            reason = f"⭐ Vous avez adoré ({book['user_rating']}/5) - {format_reasons(book['reasons'])}"
                        elif book['user_rating'] <= 2:
                            reason = f"↩️ Vous pourriez réévaluer ({book['user_rating']}/5)"
                        else:
                            reason = f"📖 Déjà lu ({book['user_rating']}/5) - {format_reasons(book['reasons'])}"
                    else:
                        reason = "📚 Déjà consulté - " + format_reasons(book['reasons'])
                    evaluated_included += 1
                else:
                    if book['avg_rating'] >= 4.5 and book['rating_count'] > 5:
                        reason = f"🏆 Excellent livre ({book['avg_rating']:.1f}/5) - " + format_reasons(book['reasons'])
                    elif book['avg_rating'] >= 4.0:
                        reason = f"👍 Très bien noté ({book['avg_rating']:.1f}/5) - " + format_reasons(book['reasons'])
                    else:
                        reason = "🎯 Recommandation personnalisée - " + format_reasons(book['reasons'])
                    non_evaluated_included += 1
                
                final_recommendations.append({
                    **book,
                    'reason': reason or "Recommandé pour vous"
                })
                
                categories_used.add(book['category_id'])
                authors_used.add(book['author'])
                if cluster_id is not None:
                    clusters_used.add(cluster_id)
        
        # GARANTIE: Si moins de recommandations que demandé, prendre les meilleurs restants
        if len(final_recommendations) < n_recommendations:
            print(f"⚠️ Seulement {len(final_recommendations)} recommandations après diversité, ajout des meilleurs restants")
            for book in recommended_books:
                if book['id'] not in [r['id'] for r in final_recommendations]:
                    reason = book.get('reason', 'Suggestion basée sur nos collections')
                    if not reason and book['is_evaluated'] and book['user_rating']:
                        reason = f"Vous avez noté {book['user_rating']}/5"
                    
                    final_recommendations.append({
                        **book,
                        'reason': reason or "Suggestion personnalisée"
                    })
                
                if len(final_recommendations) >= n_recommendations:
                    break
        
        print(f"✅ {len(final_recommendations)} recommandations FINALES pour user {user_id} "
              f"({evaluated_included} déjà évalués, {non_evaluated_included} nouveaux)")
        
        return final_recommendations
        
    except Exception as e:
        print(f"❌ Erreur recommandations intelligentes: {e}")
        traceback.print_exc()
        return get_enhanced_fallback_recommendations()

def get_enhanced_fallback_recommendations():
    """Fallback amélioré qui retourne TOUJOURS des livres"""
    try:
        print("🔄 Utilisation du fallback amélioré")
        
        if books_df is None or books_df.empty:
            print("❌ Base de données vide dans fallback")
            return []
        
        fallback_books = []
        
        for idx, book in books_df.iterrows():
            if len(fallback_books) >= 12:
                break
            
            # Calculer un score basique GARANTI
            score = 0.5 + (idx % 10) * 0.05
            
            # Score de popularité
            if ratings_df is not None and not ratings_df.empty:
                book_ratings = ratings_df[ratings_df['book_id'] == book['id']]
                if not book_ratings.empty:
                    avg_rating = book_ratings['rating'].mean()
                    rating_count = len(book_ratings)
                    score += avg_rating * 0.2
                    score += np.log1p(rating_count) * 0.1
            
            # Score minimal
            if score < 0.3:
                score = 0.3
            
            # Récupérer la note moyenne
            avg_rating = 3.0
            rating_count = 0
            if ratings_df is not None and not ratings_df.empty:
                book_ratings = ratings_df[ratings_df['book_id'] == book['id']]
                if not book_ratings.empty:
                    avg_rating = book_ratings['rating'].mean()
                    rating_count = len(book_ratings)
            
            fallback_books.append({
                'id': int(book['id']),
                'title': str(book['title']),
                'author': str(book['author']),
                'category_id': int(book['category_id']),
                'price': float(book['price']),
                'image_url': book.get('image_url', f'https://via.placeholder.com/220x300?text={book["title"]}'),
                'score': float(score),
                'avg_rating': float(avg_rating),
                'rating_count': int(rating_count),
                'reason': f"Livre populaire ({avg_rating:.1f}/5)" if rating_count > 0 else "Découverte recommandée"
            })
        
        # GARANTIE: Toujours retourner au moins 12 livres
        if len(fallback_books) < 12:
            print(f"⚠️ Seulement {len(fallback_books)} livres, duplicata autorisé")
            while len(fallback_books) < 12 and len(fallback_books) > 0:
                for book in fallback_books.copy():
                    if len(fallback_books) >= 12:
                        break
                    new_book = book.copy()
                    new_book['reason'] = "Suggestion supplémentaire"
                    fallback_books.append(new_book)
        
        # Trier par score
        fallback_books.sort(key=lambda x: x['score'], reverse=True)
        
        print(f"✅ {len(fallback_books)} livres dans fallback")
        return fallback_books[:12]
        
    except Exception as e:
        print(f"❌ Erreur fallback: {e}")
        return [
            {
                'id': 999,
                'title': 'Livre recommandé',
                'author': 'Auteur',
                'category_id': 1,
                'price': 19.99,
                'image_url': 'https://via.placeholder.com/220x300?text=Livre',
                'reason': 'Recommandation système'
            }
        ]

def format_reasons(reasons):
    """Formate les raisons pour l'affichage"""
    if not reasons:
        return "Recommandé pour vous"
    
    if len(reasons) > 2:
        return f"{reasons[0]}, {reasons[1]}"
    return ", ".join(reasons)

# ============================================================================
# ROUTES API OPTIMISÉES
# ============================================================================

@app.route('/')
def home():
    return "API de Recommandation avec MySQL, K-Means Optimisé et Évaluation 🚀"

@app.route('/health')
def health():
    return jsonify({
        'status': 'healthy',
        'books': len(books_df) if books_df is not None else 0,
        'users_with_profiles': len(user_features),
        'clusters': len(set(book_clusters.values())) if book_clusters else 0,
        'model': 'K-Means Optimisé',
        'hyperparams': HYPERPARAMS_CONFIG['kmeans'],
        'evaluation_ready': len(evaluation_history) > 0
    })

@app.route('/initialize', methods=['POST'])
def initialize():
    """Initialise le modèle"""
    try:
        load_data_from_db()
        return jsonify({
            'status': 'success',
            'message': f'Modèle initialisé avec {len(books_df)} livres et {len(user_features)} profils',
            'clusters': len(set(book_clusters.values())) if book_clusters else 0,
            'hyperparams': HYPERPARAMS_CONFIG['kmeans'],
            'data_quality_issues': len(data_quality_report.get('issues', []))
        })
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/recommend/<int:book_id>', methods=['GET'])
def recommend(book_id):
    """Recommandations pour un livre"""
    try:
        user_id = request.args.get('user_id', type=int)
        
        recommendations = get_recommendations(
            book_id, 
            user_id=user_id,
            n_recommendations=8
        )
        
        return jsonify({
            'status': 'success',
            'recommendations': recommendations,
            'count': len(recommendations),
            'model': 'K-Means',
            'hyperparams_used': HYPERPARAMS_CONFIG['kmeans']
        })
    except Exception as e:
        print(f"❌ Erreur route /recommend: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/intelligent-recommendations/<int:user_id>', methods=['GET'])
def intelligent_recommendations(user_id):
    """Recommandations intelligentes basées sur les préférences"""
    try:
        print(f"🧠 Début recommandations intelligentes pour user {user_id}")
        
        # Forcer le chargement des données
        load_data_from_db()
        
        if books_df is None or books_df.empty:
            print("❌ Pas de livres dans la base")
            return jsonify({
                'status': 'success',
                'recommendations': [],
                'count': 0,
                'message': 'Base de données vide'
            })
        
        print(f"📚 {len(books_df)} livres disponibles")
        
        # Obtenir les recommandations
        recommendations = get_intelligent_recommendations(user_id)
        
        print(f"✅ {len(recommendations)} recommandations générées")
        
        # Formater la réponse
        formatted_recommendations = []
        for rec in recommendations:
            formatted_rec = {
                'id': rec['id'],
                'title': rec['title'],
                'author': rec['author'],
                'reason': rec.get('reason', 'Recommandé pour vous'),
                'category_id': rec.get('category_id', 0),
                'price': rec.get('price', 0),
                'image_url': rec.get('image_url', f'https://via.placeholder.com/220x300?text={rec["title"]}'),
                'score': rec.get('score', 0.5)
            }
            formatted_recommendations.append(formatted_rec)
        
        return jsonify({
            'status': 'success',
            'recommendations': formatted_recommendations,
            'count': len(formatted_recommendations),
            'algorithm': 'intelligent',
            'model': 'K-Means Optimisé',
            'hyperparams': HYPERPARAMS_CONFIG,
            'timestamp': datetime.now().isoformat(),
            'books_in_db': len(books_df)
        })
        
    except Exception as e:
        print(f"❌ Erreur route recommandations intelligentes: {e}")
        traceback.print_exc()
        
        # Fallback
        fallback_recs = get_enhanced_fallback_recommendations()
        
        return jsonify({
            'status': 'success',
            'recommendations': fallback_recs,
            'count': len(fallback_recs),
            'algorithm': 'fallback',
            'timestamp': datetime.now().isoformat()
        })

@app.route('/data-quality', methods=['GET'])
def get_data_quality():
    """Retourne le rapport de qualité des données"""
    try:
        return jsonify({
            'status': 'success',
            'quality_report': data_quality_report
        })
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/evaluate/clustering', methods=['GET'])
def evaluate_clustering_route():
    """Évalue le clustering"""
    try:
        if book_features_matrix is None or not book_clusters:
            return jsonify({'status': 'error', 'message': 'Clustering non disponible'}), 400
        
        # Préparer les données
        clusters = []
        valid_indices = []
        
        for idx, book_id in index_to_book_id.items():
            cluster_id = book_clusters.get(book_id, -1)
            if cluster_id != -1:
                clusters.append(cluster_id)
                valid_indices.append(idx)
        
        if not clusters:
            return jsonify({'status': 'error', 'message': 'Aucun cluster valide'}), 400
        
        clusters_array = np.array(clusters)
        features_subset = book_features_matrix[valid_indices]
        
        # Évaluer
        metrics = evaluate_clustering(features_subset, clusters_array)
        
        return jsonify({
            'status': 'success',
            'metrics': metrics,
            'model': 'K-Means',
            'hyperparams': HYPERPARAMS_CONFIG['kmeans']
        })
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/evaluate/recommendations/<int:user_id>', methods=['GET'])
def evaluate_user_recommendations(user_id):
    """Évalue les recommandations pour un utilisateur"""
    try:
        n_recommendations = request.args.get('n', default=10, type=int)
        
        # Générer les recommandations
        recommendations = get_intelligent_recommendations(user_id, n_recommendations)
        
        # Récupérer l'historique
        user_history = {'evaluated_books': []}
        if ratings_df is not None:
            user_ratings = ratings_df[ratings_df['user_id'] == user_id]
            user_history['evaluated_books'] = user_ratings['book_id'].tolist()
        
        # Évaluer
        rec_metrics = evaluate_recommendations(
            recommendations,
            user_history=user_history,
            all_books=books_df['id'].tolist() if books_df is not None else []
        )
        
        # Générer un rapport
        report = generate_evaluation_report(
            clustering_metrics=None,
            recommendation_metrics=rec_metrics
        )
        
        return jsonify({
            'status': 'success',
            'evaluation': {
                'recommendations': rec_metrics,
                'report': report
            },
            'user_id': user_id
        })
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/optimize', methods=['POST'])
def optimize_hyperparameters_route():
    """Optimise les hyperparamètres du modèle"""
    try:
        if book_features_matrix is None or len(book_features_matrix) < 10:
            return jsonify({
                'status': 'error', 
                'message': 'Pas assez de données pour l\'optimisation'
            }), 400
        
        # Configurations à tester
        configs_to_test = [
            {
                'n_clusters': find_optimal_clusters(book_features_matrix),
                'n_init': 20,
                'max_iter': 500,
                'algorithm': 'elkan',
                'tol': 1e-5,
                'random_state': 42
            },
            {
                'n_clusters': find_optimal_clusters(book_features_matrix),
                'n_init': 15,
                'max_iter': 400,
                'algorithm': 'auto',
                'tol': 1e-4,
                'random_state': 42
            },
            {
                'n_clusters': min(10, len(book_features_matrix) // 5),
                'n_init': 25,
                'max_iter': 600,
                'algorithm': 'full',
                'tol': 1e-5,
                'random_state': 42
            }
        ]
        
        # Évaluer chaque configuration
        results = evaluate_multiple_configs(book_features_matrix, configs_to_test)
        
        if not results:
            return jsonify({'status': 'error', 'message': 'Aucune configuration valide'}), 400
        
        # Appliquer la meilleure configuration
        best_config = results[0]['config']
        
        # Mettre à jour la configuration globale
        HYPERPARAMS_CONFIG['kmeans'].update(best_config)
        
        # Réentraîner le modèle avec la meilleure configuration
        success = train_kmeans_model_optimized(best_config)
        
        if not success:
            return jsonify({'status': 'error', 'message': 'Échec réentraînement'}), 500
        
        return jsonify({
            'status': 'success',
            'message': 'Hyperparamètres optimisés avec succès',
            'best_config': best_config,
            'evaluation_results': results,
            'new_hyperparams': HYPERPARAMS_CONFIG['kmeans']
        })
        
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/hyperparams', methods=['GET', 'PUT'])
def manage_hyperparams():
    """Gère les hyperparamètres"""
    if request.method == 'GET':
        return jsonify({
            'status': 'success',
            'hyperparams': HYPERPARAMS_CONFIG
        })
    
    elif request.method == 'PUT':
        try:
            new_config = request.json
            
            # Valider et mettre à jour la configuration
            if 'kmeans' in new_config:
                HYPERPARAMS_CONFIG['kmeans'].update(new_config['kmeans'])
            
            if 'features' in new_config:
                HYPERPARAMS_CONFIG['features'].update(new_config['features'])
            
            if 'recommendations' in new_config:
                HYPERPARAMS_CONFIG['recommendations'].update(new_config['recommendations'])
            
            # Réentraîner le modèle si nécessaire
            if 'kmeans' in new_config:
                train_kmeans_model_optimized()
            
            return jsonify({
                'status': 'success',
                'message': 'Hyperparamètres mis à jour',
                'hyperparams': HYPERPARAMS_CONFIG
            })
        except Exception as e:
            return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/debug/full/<int:user_id>', methods=['GET'])
def debug_full(user_id):
    """Debug complet avec évaluation"""
    try:
        # 1. Recharger les données
        load_data_from_db()
        
        # 2. Évaluer le clustering
        clustering_metrics = None
        if book_features_matrix is not None and book_clusters:
            clusters = []
            valid_indices = []
            for idx, book_id in index_to_book_id.items():
                cluster_id = book_clusters.get(book_id, -1)
                if cluster_id != -1:
                    clusters.append(cluster_id)
                    valid_indices.append(idx)
            
            if clusters:
                clusters_array = np.array(clusters)
                features_subset = book_features_matrix[valid_indices]
                clustering_metrics = evaluate_clustering(features_subset, clusters_array)
        
        # 3. Générer des recommandations
        recommendations = get_intelligent_recommendations(user_id)
        
        # 4. Évaluer les recommandations
        user_history = {'evaluated_books': []}
        if ratings_df is not None:
            user_ratings = ratings_df[ratings_df['user_id'] == user_id]
            user_history['evaluated_books'] = user_ratings['book_id'].tolist()
        
        rec_metrics = evaluate_recommendations(
            recommendations,
            user_history=user_history,
            all_books=books_df['id'].tolist() if books_df is not None else []
        )
        
        # 5. Rapport complet
        report = generate_evaluation_report(
            clustering_metrics=clustering_metrics,
            recommendation_metrics=rec_metrics
        )
        
        return jsonify({
            'status': 'success',
            'user_id': user_id,
            'clustering_evaluation': clustering_metrics,
            'recommendation_evaluation': rec_metrics,
            'full_report': report,
            'data_quality': data_quality_report,
            'hyperparams': HYPERPARAMS_CONFIG,
            'n_recommendations': len(recommendations)
        })
        
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/user-profile/<int:user_id>', methods=['GET'])
def user_profile(user_id):
    """Récupère le profil utilisateur"""
    try:
        profile = get_user_profile(user_id)
        
        return jsonify({
            'status': 'success',
            'profile': {
                'user_id': user_id,
                'avg_rating': profile['avg_rating'],
                'total_ratings': profile['total_ratings'],
                'preferred_categories': list(profile['category_prefs'].keys())[:3],
                'preferred_authors': list(profile['author_prefs'].keys())[:5],
                'price_range': profile['preferred_price_range'],
                'last_updated': profile['last_updated']
            }
        })
    except Exception as e:
        print(f"❌ Erreur route /user-profile: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/refresh-profile/<int:user_id>', methods=['POST'])
def refresh_profile(user_id):
    """Force le rafraîchissement du profil"""
    try:
        recalculate_user_profile(user_id)
        
        if user_id in user_features:
            return jsonify({
                'status': 'success',
                'message': f'Profil {user_id} rafraîchi',
                'profile': get_user_profile(user_id)
            })
        else:
            return jsonify({'status': 'error', 'message': 'Erreur rafraîchissement'}), 500
            
    except Exception as e:
        print(f"❌ Erreur route /refresh-profile: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

# ============================================================================
# EXÉCUTION PRINCIPALE
# ============================================================================

if __name__ == '__main__':
    print("🚀 Démarrage API Flask avec MySQL, K-Means Optimisé et Évaluation...")
    print("📊 Configuration des hyperparamètres:")
    print(f"   K-Means: n_init={HYPERPARAMS_CONFIG['kmeans']['n_init']}, "
          f"max_iter={HYPERPARAMS_CONFIG['kmeans']['max_iter']}, "
          f"algorithm={HYPERPARAMS_CONFIG['kmeans']['algorithm']}")
    print(f"   Features: PCA={HYPERPARAMS_CONFIG['features']['use_pca']}, "
          f"variance={HYPERPARAMS_CONFIG['features']['pca_variance']}")
    
    # Charger les données
    load_data_from_db()
    
    # Exécuter une évaluation automatique au démarrage
    if book_clusters and book_features_matrix is not None:
        print("\n" + "="*50)
        print("ÉVALUATION AUTOMATIQUE AU DÉMARRAGE")
        print("="*50)
        
        clusters = []
        valid_indices = []
        for idx, book_id in index_to_book_id.items():
            cluster_id = book_clusters.get(book_id, -1)
            if cluster_id != -1:
                clusters.append(cluster_id)
                valid_indices.append(idx)
        
        if clusters:
            clusters_array = np.array(clusters)
            features_subset = book_features_matrix[valid_indices]
            
            if len(np.unique(clusters_array)) > 1:
                metrics = evaluate_clustering(features_subset, clusters_array)
                print(f"\n📊 Résumé clustering:")
                print(f"   Score Silhouette: {metrics.get('silhouette_score', 0):.3f}")
                print(f"   Davies-Bouldin: {metrics.get('davies_bouldin', 0):.3f}")
                print(f"   {metrics.get('n_clusters', 0)} clusters")
        
        # Afficher le rapport de qualité
        if data_quality_report:
            print(f"\n📈 Qualité des données:")
            print(f"   Livres: {data_quality_report.get('books', {}).get('total', 0)}")
            print(f"   Évaluations: {data_quality_report.get('ratings', {}).get('total', 0)}")
            if 'issues' in data_quality_report:
                print(f"   Problèmes détectés: {len(data_quality_report['issues'])}")
                for issue in data_quality_report['issues']:
                    print(f"     - {issue}")
    
    print(f"\n🌐 API démarrée sur http://0.0.0.0:5002")
    print("📌 Endpoints disponibles:")
    print("   GET  /health - Vérifier l'état du service")
    print("   POST /initialize - Initialiser le modèle")
    print("   GET  /recommend/<book_id> - Recommandations pour un livre")
    print("   GET  /intelligent-recommendations/<user_id> - Recommandations personnalisées")
    print("   POST /optimize - Optimiser les hyperparamètres")
    print("   GET/PUT /hyperparams - Gérer les hyperparamètres")
    print("   GET  /debug/full/<user_id> - Debug complet")
    
    app.run(host='0.0.0.0', port=5002, debug=True)