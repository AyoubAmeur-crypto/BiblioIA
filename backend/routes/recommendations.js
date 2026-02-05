const express = require('express');
const router = express.Router();
const axios = require('axios');
const pool = require('../config/database');
const authMiddleware = require('../middleware/auth');

const PYTHON_API = 'http://localhost:5002';

// GET recommandations pour un livre
router.get('/book/:bookId', authMiddleware, async (req, res) => {
  try {
    const { bookId } = req.params;
    const { id: user_id } = req.user;
    const differentCategories = req.query.different_categories === '1';
    
    console.log(`Recommandations pour livre ${bookId}, utilisateur ${user_id}`);
    
    const connection = await pool.getConnection();
    await connection.query(
      'INSERT INTO user_recommendations (user_id, book_id, interaction_type) VALUES (?, ?, ?)',
      [user_id, bookId, 'view']
    );
    
    let pythonRecommendations = [];
    try {
      const params = { user_id };
      if (differentCategories) params.different_categories = '1';
      const response = await axios.get(`${PYTHON_API}/recommend/${bookId}`, {
        params
      });
      
      if (response.data.status === 'success') {
        pythonRecommendations = response.data.recommendations || [];
      }
    } catch (pythonError) {
      console.log('⚠️ API Python non disponible:', pythonError.message);
    }
    
    // 3. Si Python retourne des recommandations
    if (pythonRecommendations.length > 0) {
      const bookIds = pythonRecommendations.map(r => r.id);
      const placeholders = bookIds.map(() => '?').join(',');
      
      const [books] = await connection.query(
        `SELECT b.*, c.name as category_name FROM books b 
         LEFT JOIN categories c ON b.category_id = c.id 
         WHERE b.id IN (${placeholders})`,
        bookIds
      );
      
      // Fusionner les données
      const recommendations = pythonRecommendations.map(rec => {
        const bookData = books.find(b => b.id === rec.id) || {};
        return {
          id: rec.id,
          title: rec.title || bookData.title,
          author: rec.author || bookData.author,
          category_id: rec.category_id || bookData.category_id,
          category_name: bookData.category_name || 'Livre',
          price: rec.price || bookData.price || 0,
          image_url: rec.image_url || bookData.image_url || 'https://via.placeholder.com/220x300',
          similarity: rec.similarity || 0.8,
          reason: rec.reason || 'Same category'
        };
      });
      
      connection.release();
      return res.json(recommendations);
    }
    
    // 4. Fallback: livres aléatoires
    const [books] = await connection.query(`
      SELECT b.*, c.name as category_name 
      FROM books b
      LEFT JOIN categories c ON b.category_id = c.id
      WHERE b.id != ?
      ORDER BY RAND()
      LIMIT 4
    `, [bookId]);
    
    connection.release();
    
    // Ajouter une raison par défaut
    const recommendations = books.map(book => ({
      ...book,
      reason: 'You might like this'
    }));
    
    res.json(recommendations);
    
  } catch (error) {
    console.error('❌ Erreur recommandations:', error.message);
    
    // Dernier fallback
    try {
      const connection = await pool.getConnection();
      const [books] = await connection.query(`
        SELECT b.*, c.name as category_name 
        FROM books b
        LEFT JOIN categories c ON b.category_id = c.id
        ORDER BY RAND()
        LIMIT 4
      `);
      connection.release();
      
      const recommendations = books.map(book => ({
        ...book,
        reason: 'Popular picks'
      }));
      
      res.json(recommendations);
    } catch (fallbackError) {
      res.status(500).json({ error: 'Erreur serveur' });
    }
  }
});

// POST mettre à jour après évaluation
router.post('/update-after-rating', authMiddleware, async (req, res) => {
  try {
    const { book_id, rating, action = 'rating' } = req.body;
    const { id: user_id } = req.user;
    
    console.log(`📝 Mise à jour profil pour user ${user_id}, livre ${book_id}, note ${rating}`);
    
    // 1. Enregistrer dans MySQL
    const connection = await pool.getConnection();
    
    // Enregistrer l'interaction
    await connection.query(
      'INSERT INTO user_recommendations (user_id, book_id, interaction_type) VALUES (?, ?, ?)',
      [user_id, book_id, action]
    );
    
    // Mettre à jour les stats
    await connection.query(
      `INSERT INTO recommendation_stats (user_id, total_recommendations, total_clicks) 
       VALUES (?, 1, 1)
       ON DUPLICATE KEY UPDATE 
       total_recommendations = total_recommendations + 1,
       total_clicks = total_clicks + 1`,
      [user_id]
    );
    
    connection.release();
    
    // 2. Appeler l'API Python
    try {
      await axios.post(`${PYTHON_API}/update-profile`, {
        user_id,
        book_id,
        action: action,
        rating: rating
      });
      console.log('✅ Profil mis à jour dans Python');
    } catch (pythonError) {
      console.log('⚠️ API Python non disponible pour mise à jour profil:', pythonError.message);
    }
    
    res.json({ message: 'Profil mis à jour avec succès' });
    
  } catch (error) {
    console.error('❌ Erreur mise à jour profil:', error.message);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// POST mettre à jour après panier
router.post('/update-after-cart', authMiddleware, async (req, res) => {
  try {
    const { book_id } = req.body;
    const { id: user_id } = req.user;
    
    console.log(`🛒 Mise à jour panier pour user ${user_id}, livre ${book_id}`);
    
    // 1. Enregistrer dans MySQL
    const connection = await pool.getConnection();
    
    await connection.query(
      'INSERT INTO user_recommendations (user_id, book_id, interaction_type) VALUES (?, ?, ?)',
      [user_id, book_id, 'cart']
    );
    
    connection.release();
    
    // 2. Appeler l'API Python
    try {
      await axios.post(`${PYTHON_API}/update-profile`, {
        user_id,
        book_id,
        action: 'cart'
      });
      console.log('✅ Panier mis à jour dans Python');
    } catch (pythonError) {
      console.log('⚠️ API Python non disponible pour mise à jour panier:', pythonError.message);
    }
    
    res.json({ message: 'Panier mis à jour avec succès' });
    
  } catch (error) {
    console.error('❌ Erreur mise à jour panier:', error.message);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// GET profil utilisateur
router.get('/user-profile', authMiddleware, async (req, res) => {
  try {
    const { id: user_id } = req.user;
    
    console.log(`👤 Récupération profil user ${user_id}`);
    
    // 1. Essayer l'API Python d'abord
    let profile = null;
    try {
      const response = await axios.get(`${PYTHON_API}/user-profile/${user_id}`);
      if (response.data.status === 'success') {
        profile = response.data.profile;
        console.log('✅ Profil récupéré depuis Python');
      }
    } catch (pythonError) {
      console.log('⚠️ API Python non disponible pour profil:', pythonError.message);
    }
    
    // 2. Récupérer les données depuis MySQL
    const connection = await pool.getConnection();
    
    // Statistiques
    const [stats] = await connection.query(`
      SELECT 
        COUNT(*) as total_interactions,
        COUNT(DISTINCT book_id) as unique_books,
        AVG(CASE WHEN interaction_type = 'rating' THEN 1 ELSE 0 END) * 100 as rating_percentage
      FROM user_recommendations 
      WHERE user_id = ?
    `, [user_id]);
    
    // Dernières interactions
    const [interactions] = await connection.query(`
      SELECT ur.*, b.title, b.author, b.category_id
      FROM user_recommendations ur
      JOIN books b ON ur.book_id = b.id
      WHERE ur.user_id = ?
      ORDER BY ur.created_at DESC
      LIMIT 10
    `, [user_id]);
    
    // Évaluations
    const [ratings] = await connection.query(`
      SELECT r.rating, b.title, b.author, b.category_id
      FROM ratings r
      JOIN books b ON r.book_id = b.id
      WHERE r.user_id = ?
      ORDER BY r.rating DESC
      LIMIT 5
    `, [user_id]);
    
    connection.release();
    
    // 3. Construire le profil complet
    const fullProfile = {
      user_id: user_id,
      // Données Python
      ...(profile || {}),
      // Données MySQL
      stats: stats[0] || { total_interactions: 0, unique_books: 0, rating_percentage: 0 },
      recent_interactions: interactions,
      top_ratings: ratings,
      // Calculs
      favorite_categories: getFavoriteCategories(interactions),
      favorite_authors: getFavoriteAuthors(ratings),
      engagement_score: calculateEngagementScore(stats[0], interactions)
    };
    
    res.json(fullProfile);
    
  } catch (error) {
    console.error('❌ Erreur profil:', error.message);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// NOUVELLE ROUTE: Recommandations personnalisées
router.get('/personalized', authMiddleware, async (req, res) => {
  try {
    const { id: user_id } = req.user;
    
    console.log(`🎯 Recommandations personnalisées pour user ${user_id}`);
    
    // 1. Essayer l'API Python
    let personalizedRecs = [];
    try {
      const response = await axios.get(`${PYTHON_API}/recommend/user/${user_id}`);
      if (response.data.status === 'success') {
        personalizedRecs = response.data.recommendations || [];
        console.log(`✅ ${personalizedRecs.length} recommandations depuis Python`);
      }
    } catch (pythonError) {
      console.log('⚠️ API Python non disponible:', pythonError.message);
    }
    
    // 2. Si Python retourne des recommandations
    if (personalizedRecs.length > 0) {
      const bookIds = personalizedRecs.map(r => r.id);
      const placeholders = bookIds.map(() => '?').join(',');
      
      const connection = await pool.getConnection();
      const [books] = await connection.query(
        `SELECT b.*, c.name as category_name FROM books b 
         LEFT JOIN categories c ON b.category_id = c.id 
         WHERE b.id IN (${placeholders})`,
        bookIds
      );
      connection.release();
      
      const recommendations = personalizedRecs.map(rec => {
        const bookData = books.find(b => b.id === rec.id) || {};
        return {
          ...rec,
          category_name: bookData.category_name || 'Livre',
          reason: rec.reason || 'Personnalisé selon vos préférences'
        };
      });
      
      return res.json(recommendations);
    }
    
    // 3. Fallback: Basé sur l'historique utilisateur
    const connection = await pool.getConnection();
    
    // Récupérer les catégories préférées
    const [preferredCategories] = await connection.query(`
      SELECT b.category_id, COUNT(*) as count
      FROM user_recommendations ur
      JOIN books b ON ur.book_id = b.id
      WHERE ur.user_id = ? AND ur.interaction_type IN ('rating', 'cart')
      GROUP BY b.category_id
      ORDER BY count DESC
      LIMIT 3
    `, [user_id]);
    
    const categoryIds = preferredCategories.map(c => c.category_id);
    
    // Livres dans ces catégories
    let recommendations = [];
    if (categoryIds.length > 0) {
      const placeholders = categoryIds.map(() => '?').join(',');
      const [books] = await connection.query(`
        SELECT b.*, c.name as category_name 
        FROM books b
        LEFT JOIN categories c ON b.category_id = c.id
        WHERE b.category_id IN (${placeholders})
        AND b.id NOT IN (
          SELECT book_id FROM user_recommendations WHERE user_id = ?
        )
        ORDER BY RAND()
        LIMIT 8
      `, [...categoryIds, user_id]);
      
      recommendations = books.map(book => ({
        ...book,
        reason: `Catégorie: ${book.category_name}`
      }));
    }
    
    // 4. Fallback final: livres populaires
    if (recommendations.length === 0) {
      const [popularBooks] = await connection.query(`
        SELECT b.*, c.name as category_name, 
               COALESCE(AVG(r.rating), 0) as avg_rating,
               COUNT(r.id) as rating_count
        FROM books b
        LEFT JOIN categories c ON b.category_id = c.id
        LEFT JOIN ratings r ON b.id = r.book_id
        WHERE b.id NOT IN (
          SELECT book_id FROM user_recommendations WHERE user_id = ?
        )
        GROUP BY b.id
        HAVING rating_count > 0
        ORDER BY avg_rating DESC, rating_count DESC
        LIMIT 8
      `, [user_id]);
      
      recommendations = popularBooks.map(book => ({
        ...book,
        reason: `Note moyenne: ${book.avg_rating.toFixed(1)}/5`
      }));
    }
    
    connection.release();
    
    res.json(recommendations);
    
  } catch (error) {
    console.error('❌ Erreur recommandations personnalisées:', error.message);
    res.json([]); // Retourner tableau vide en cas d'erreur
  }
});

// Fonctions utilitaires
function getFavoriteCategories(interactions) {
  const categoryCount = {};
  interactions.forEach(interaction => {
    if (interaction.category_id) {
      categoryCount[interaction.category_id] = (categoryCount[interaction.category_id] || 0) + 1;
    }
  });
  
  return Object.entries(categoryCount)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 3)
    .map(([categoryId, count]) => ({ category_id: parseInt(categoryId), count }));
}

function getFavoriteAuthors(ratings) {
  const authorScores = {};
  ratings.forEach(rating => {
    if (rating.author) {
      authorScores[rating.author] = (authorScores[rating.author] || 0) + rating.rating;
    }
  });
  
  return Object.entries(authorScores)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 5)
    .map(([author, score]) => ({ author, score }));
}

function calculateEngagementScore(stats, interactions) {
  if (!stats || !interactions.length) return 0;
  
  const daysSinceFirst = interactions.length > 0 ? 
    Math.max(1, (new Date() - new Date(interactions[interactions.length - 1].created_at)) / (1000 * 60 * 60 * 24)) : 30;
  
  const interactionRate = stats.total_interactions / daysSinceFirst;
  const ratingRatio = (stats.rating_percentage || 0) / 100;
  
  return Math.min(100, Math.round((interactionRate * 20) + (ratingRatio * 80)));
}


// MODIFIEZ la route /refresh-profile dans recommendation.js
router.post('/refresh-profile', authMiddleware, async (req, res) => {
  try {
    const { id: user_id } = req.user;
    
    console.log(`🔄 Rafraîchissement profil user ${user_id} (version simplifiée)`);
    
    // 1. Rafraîchir le profil dans la base MySQL
    const connection = await pool.getConnection();
    
    // Recalculer les préférences basées sur les évaluations
    const [userRatings] = await connection.query(`
      SELECT r.rating, b.category_id, b.author
      FROM ratings r
      JOIN books b ON r.book_id = b.id
      WHERE r.user_id = ?
    `, [user_id]);
    
    if (userRatings.length > 0) {
      // Mettre à jour les préférences de catégorie
      for (const rating of userRatings) {
        await connection.query(`
          INSERT INTO user_preferences (user_id, category_id, preference_score, rating_count)
          VALUES (?, ?, ?, 1)
          ON DUPLICATE KEY UPDATE 
          preference_score = preference_score + ?,
          rating_count = rating_count + 1,
          last_updated = NOW()
        `, [user_id, rating.category_id, rating.rating, rating.rating]);
        
        // Mettre à jour les préférences d'auteur
        await connection.query(`
          INSERT INTO user_preferred_authors (user_id, author_name, preference_score, rating_count)
          VALUES (?, ?, ?, 1)
          ON DUPLICATE KEY UPDATE 
          preference_score = preference_score + ?,
          rating_count = rating_count + 1,
          last_updated = NOW()
        `, [user_id, rating.author, rating.rating, rating.rating]);
      }
    }
    
    connection.release();
    
    // 2. Essayer l'API Python (optionnel)
    let pythonRecommendations = [];
    try {
      // Appeler la nouvelle route Python
      const response = await axios.post(`${PYTHON_API}/refresh-user-recommendations/${user_id}`);
      if (response.data.status === 'success') {
        pythonRecommendations = response.data.recommendations || [];
        console.log(`✅ ${pythonRecommendations.length} recommandations depuis Python`);
      }
    } catch (pythonError) {
      console.log('⚠️ API Python non disponible (ignoré):', pythonError.message);
      // Ce n'est pas grave si Python n'est pas disponible
    }
    
    // 3. Si Python retourne des recommandations, les utiliser
    let recommendations = [];
    if (pythonRecommendations.length > 0) {
      recommendations = pythonRecommendations;
    } else {
      // 4. Fallback: recommandations basées sur les préférences MySQL
      const connection2 = await pool.getConnection();
      
      // Récupérer les catégories préférées
      const [preferredCategories] = await connection2.query(`
        SELECT category_id, preference_score
        FROM user_preferences
        WHERE user_id = ?
        ORDER BY preference_score DESC
        LIMIT 3
      `, [user_id]);
      
      const categoryIds = preferredCategories.map(c => c.category_id);
      
      if (categoryIds.length > 0) {
        const placeholders = categoryIds.map(() => '?').join(',');
        const [books] = await connection2.query(`
          SELECT b.*, c.name as category_name 
          FROM books b
          LEFT JOIN categories c ON b.category_id = c.id
          WHERE b.category_id IN (${placeholders})
          AND b.id NOT IN (
            SELECT book_id FROM ratings WHERE user_id = ?
          )
          ORDER BY RAND()
          LIMIT 8
        `, [...categoryIds, user_id]);
        
        recommendations = books.map(book => ({
          id: book.id,
          title: book.title,
          author: book.author,
          category_id: book.category_id,
          category_name: book.category_name || 'Livre',
          price: book.price || 0,
          image_url: book.image_url || 'https://via.placeholder.com/220x300',
          reason: `Basé sur vos préférences: ${book.category_name}`
        }));
      } else {
        // Si pas de préférences, livres populaires
        const [popularBooks] = await connection2.query(`
          SELECT b.*, c.name as category_name, 
                 COALESCE(AVG(r.rating), 0) as avg_rating,
                 COUNT(r.id) as rating_count
          FROM books b
          LEFT JOIN categories c ON b.category_id = c.id
          LEFT JOIN ratings r ON b.id = r.book_id
          WHERE b.id NOT IN (
            SELECT book_id FROM ratings WHERE user_id = ?
          )
          GROUP BY b.id
          HAVING rating_count > 0
          ORDER BY avg_rating DESC
          LIMIT 8
        `, [user_id]);
        
        recommendations = popularBooks.map(book => ({
          id: book.id,
          title: book.title,
          author: book.author,
          category_id: book.category_id,
          category_name: book.category_name || 'Livre',
          price: book.price || 0,
          image_url: book.image_url || 'https://via.placeholder.com/220x300',
          reason: `Note moyenne: ${book.avg_rating.toFixed(1)}/5`
        }));
      }
      
      connection2.release();
    }
    
    // 5. Réponse finale
    res.json({
      message: 'Profil et recommandations rafraîchis avec succès',
      recommendations: recommendations,
      timestamp: new Date().toISOString(),
      user_id: user_id,
      recommendations_count: recommendations.length,
      source: pythonRecommendations.length > 0 ? 'python' : 'mysql'
    });
    
  } catch (error) {
    console.error('❌ Erreur rafraîchissement profil:', error.message);
    
    // Réponse d'erreur simple
    res.json({
      message: 'Rafraîchissement partiellement réussi',
      recommendations: [],
      timestamp: new Date().toISOString(),
      error: error.message,
      user_id: req.user.id
    });
  }
});



// MODIFIEZ la route /update-preferences dans recommendations.js
router.post('/update-preferences', authMiddleware, async (req, res) => {
  try {
    const { book_id, rating } = req.body;
    const { id: user_id } = req.user;
    
    console.log(`📊 Mise à jour des préférences pour user ${user_id}, livre ${book_id}, note ${rating}`);
    
    const connection = await pool.getConnection();
    
    // 1. Récupérer les infos du livre
    const [book] = await connection.query(`
      SELECT b.category_id, b.author, c.name as category_name
      FROM books b
      LEFT JOIN categories c ON b.category_id = c.id
      WHERE b.id = ?
    `, [book_id]);
    
    if (book.length === 0) {
      connection.release();
      return res.status(404).json({ error: 'Livre non trouvé' });
    }
    
    const { category_id, author, category_name } = book[0];
    
    try {
      // 2. Mettre à jour les préférences de catégorie
      const updateCategoryQuery = `
        INSERT INTO user_preferences (user_id, category_id, preference_score, rating_count)
        VALUES (?, ?, ?, 1)
        ON DUPLICATE KEY UPDATE 
        preference_score = preference_score + ?,
        rating_count = rating_count + 1,
        last_updated = NOW()
      `;
      await connection.query(updateCategoryQuery, [user_id, category_id, rating, rating]);
      
      // 3. Mettre à jour les préférences d'auteur
      const updateAuthorQuery = `
        INSERT INTO user_preferred_authors (user_id, author_name, preference_score, rating_count)
        VALUES (?, ?, ?, 1)
        ON DUPLICATE KEY UPDATE 
        preference_score = preference_score + ?,
        rating_count = rating_count + 1,
        last_updated = NOW()
      `;
      await connection.query(updateAuthorQuery, [user_id, author, rating, rating]);
      
      console.log(`✅ Préférences mises à jour: catégorie ${category_id}, auteur "${author}"`);
      
    } catch (dbError) {
      console.log(`⚠️ Erreur base de données: ${dbError.message}`);
      
      // Si les tables n'existent pas, les créer
      if (dbError.code === 'ER_NO_SUCH_TABLE') {
        console.log('🔄 Création des tables de préférences...');
        
        // Créer la table user_preferences
        await connection.query(`
          CREATE TABLE IF NOT EXISTS user_preferences (
            id INT PRIMARY KEY AUTO_INCREMENT,
            user_id INT NOT NULL,
            category_id INT NOT NULL,
            preference_score FLOAT DEFAULT 0,
            rating_count INT DEFAULT 0,
            last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE KEY unique_user_category (user_id, category_id)
          )
        `);
        
        // Créer la table user_preferred_authors
        await connection.query(`
          CREATE TABLE IF NOT EXISTS user_preferred_authors (
            id INT PRIMARY KEY AUTO_INCREMENT,
            user_id INT NOT NULL,
            author_name VARCHAR(255) NOT NULL,
            preference_score FLOAT DEFAULT 0,
            rating_count INT DEFAULT 0,
            last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE KEY unique_user_author (user_id, author_name)
          )
        `);
        
        // Réessayer les insertions
        await connection.query(`
          INSERT INTO user_preferences (user_id, category_id, preference_score, rating_count)
          VALUES (?, ?, ?, 1)
          ON DUPLICATE KEY UPDATE 
          preference_score = preference_score + ?,
          rating_count = rating_count + 1,
          last_updated = NOW()
        `, [user_id, category_id, rating, rating]);
        
        await connection.query(`
          INSERT INTO user_preferred_authors (user_id, author_name, preference_score, rating_count)
          VALUES (?, ?, ?, 1)
          ON DUPLICATE KEY UPDATE 
          preference_score = preference_score + ?,
          rating_count = rating_count + 1,
          last_updated = NOW()
        `, [user_id, author, rating, rating]);
        
        console.log('✅ Tables créées et données insérées');
      } else {
        throw dbError;
      }
    }
    
    connection.release();
    
    // 4. Appeler l'API Python pour recalculer le profil
    try {
      await axios.post(`${PYTHON_API}/refresh-user-profile/${user_id}`);
      console.log('✅ Profil Python recalculé');
    } catch (pythonError) {
      console.log('⚠️ API Python non disponible:', pythonError.message);
    }
    
    res.json({ 
      message: 'Préférences mises à jour avec succès',
      category_id,
      category_name,
      author,
      rating 
    });
    
  } catch (error) {
    console.error('❌ Erreur mise à jour préférences:', error);
    res.status(500).json({ 
      error: 'Erreur serveur',
      details: error.message,
      sqlMessage: error.sqlMessage,
      code: error.code
    });
  }
});

// MODIFIEZ la route POST update-after-rating
router.post('/update-after-rating', authMiddleware, async (req, res) => {
  try {
    const { book_id, rating, action = 'rating' } = req.body;
    const { id: user_id } = req.user;
    
    console.log(`📝 Mise à jour complète pour user ${user_id}, livre ${book_id}, note ${rating}`);
    
    const connection = await pool.getConnection();
    
    // 1. Enregistrer l'interaction
    await connection.query(
      'INSERT INTO user_recommendations (user_id, book_id, interaction_type) VALUES (?, ?, ?)',
      [user_id, book_id, action]
    );
    
    // 2. Mettre à jour les préférences (NOUVEAU)
    // Récupérer les infos du livre
    const [book] = await connection.query(`
      SELECT category_id, author 
      FROM books 
      WHERE id = ?
    `, [book_id]);
    
    if (book.length > 0) {
      const { category_id, author } = book[0];
      
      // Mettre à jour les préférences de catégorie
      await connection.query(`
        INSERT INTO user_preferences (user_id, category_id, preference_score, rating_count)
        VALUES (?, ?, ?, 1)
        ON DUPLICATE KEY UPDATE 
        preference_score = preference_score + ?,
        rating_count = rating_count + 1,
        last_updated = NOW()
      `, [user_id, category_id, rating, rating]);
      
      // Mettre à jour les préférences d'auteur
      await connection.query(`
        INSERT INTO user_preferred_authors (user_id, author_name, preference_score, rating_count)
        VALUES (?, ?, ?, 1)
        ON DUPLICATE KEY UPDATE 
        preference_score = preference_score + ?,
        rating_count = rating_count + 1,
        last_updated = NOW()
      `, [user_id, author, rating, rating]);
    }
    
    // 3. Mettre à jour les stats
    await connection.query(
      `INSERT INTO recommendation_stats (user_id, total_recommendations, total_clicks) 
       VALUES (?, 1, 1)
       ON DUPLICATE KEY UPDATE 
       total_recommendations = total_recommendations + 1,
       total_clicks = total_clicks + 1`,
      [user_id]
    );
    
    connection.release();
    
    // 4. Appeler l'API Python
    try {
      await axios.post(`${PYTHON_API}/update-profile`, {
        user_id,
        book_id,
        action: action,
        rating: rating
      });
      console.log('✅ Profil mis à jour dans Python');
    } catch (pythonError) {
      console.log('⚠️ API Python non disponible:', pythonError.message);
    }
    
    // 5. Générer de nouvelles recommandations immédiatement
    let newRecommendations = [];
    try {
      const response = await axios.post(`${PYTHON_API}/refresh-user-recommendations/${user_id}`);
      if (response.data.status === 'success') {
        newRecommendations = response.data.recommendations || [];
        console.log(`🎯 ${newRecommendations.length} nouvelles recommandations générées`);
      }
    } catch (recError) {
      console.log('⚠️ Erreur génération recommandations:', recError.message);
    }
    
    res.json({ 
      message: 'Profil et préférences mis à jour avec succès',
      recommendations_generated: newRecommendations.length > 0,
      timestamp: new Date().toISOString()
    });
    
  } catch (error) {
    console.error('❌ Erreur mise à jour profil:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

module.exports = router;