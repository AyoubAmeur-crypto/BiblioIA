    const express = require('express');
    const router = express.Router();
    const pool = require('../config/database');
    const authMiddleware = require('../middleware/auth');

    // Obtenir les statistiques de recommandation
    router.get('/stats', authMiddleware, async (req, res) => {
    try {
        const { id: user_id } = req.user;
        const connection = await pool.getConnection();

        // Livres les plus recommandés pour cet utilisateur
        const [recommendedBooks] = await connection.query(`
        SELECT b.id, b.title, b.author, COUNT(*) as recommendation_count
        FROM user_recommendations ur
        JOIN books b ON ur.book_id = b.id
        WHERE ur.user_id = ?
        GROUP BY b.id, b.title, b.author
        ORDER BY recommendation_count DESC
        LIMIT 10
        `, [user_id]);

        // Catégories les plus recommandées
        const [recommendedCategories] = await connection.query(`
        SELECT c.id, c.name, COUNT(*) as recommendation_count
        FROM user_recommendations ur
        JOIN books b ON ur.book_id = b.id
        JOIN categories c ON b.category_id = c.id
        WHERE ur.user_id = ?
        GROUP BY c.id, c.name
        ORDER BY recommendation_count DESC
        LIMIT 5
        `, [user_id]);

        // Taux de clic sur les recommandations
        const [clickStats] = await connection.query(`
        SELECT 
            COUNT(*) as total_recommendations,
            SUM(CASE WHEN clicked = 1 THEN 1 ELSE 0 END) as total_clicks,
            ROUND((SUM(CASE WHEN clicked = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) as click_rate
        FROM user_recommendations
        WHERE user_id = ?
        `, [user_id]);

        connection.release();

        res.json({
        recommended_books: recommendedBooks,
        recommended_categories: recommendedCategories,
        click_stats: clickStats[0] || { total_recommendations: 0, total_clicks: 0, click_rate: 0 }
        });
    } catch (error) {
        console.error('Erreur récupération statistiques:', error);
        res.status(500).json({ error: 'Erreur récupération statistiques' });
    }
    });

    // Enregistrer une interaction avec une recommandation
    router.post('/log-interaction', authMiddleware, async (req, res) => {
    try {
        const { book_id, action } = req.body; // 'view', 'cart', 'rating', 'purchase'
        const { id: user_id } = req.user;

        const connection = await pool.getConnection();
        
        // Vérifier si une recommandation existe pour ce livre
        const [existing] = await connection.query(
        'SELECT id FROM user_recommendations WHERE user_id = ? AND book_id = ? ORDER BY created_at DESC LIMIT 1',
        [user_id, book_id]
        );

        if (existing.length > 0) {
        // Mettre à jour le statut
        await connection.query(
            'UPDATE user_recommendations SET clicked = 1, last_interaction = NOW(), interaction_type = ? WHERE id = ?',
            [action, existing[0].id]
        );
        }

        // Toujours enregistrer une nouvelle interaction
        await connection.query(
        'INSERT INTO user_recommendations (user_id, book_id, clicked, interaction_type) VALUES (?, ?, 1, ?)',
        [user_id, book_id, action]
        );

        connection.release();
        res.json({ message: 'Interaction enregistrée' });
    } catch (error) {
        console.error('Erreur enregistrement interaction:', error);
        res.status(500).json({ error: 'Erreur enregistrement interaction' });
    }
    });

    module.exports = router;