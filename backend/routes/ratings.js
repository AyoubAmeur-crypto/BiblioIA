const express = require('express');
const router = express.Router();
const pool = require('../config/database');
const authMiddleware = require('../middleware/auth');

// ADD RATING
router.post('/add', authMiddleware, async (req, res) => {
  try {
    const { book_id, rating } = req.body;
    const { id: user_id } = req.user;

    if (!book_id || !rating || rating < 1 || rating > 5) {
      return res.status(400).json({ error: 'Valid book_id and rating (1-5) required' });
    }

    const connection = await pool.getConnection();

    // Check if rating exists
    const [existing] = await connection.query(
      'SELECT id FROM ratings WHERE user_id = ? AND book_id = ?',
      [user_id, book_id]
    );

    if (existing.length > 0) {
      // Update rating
      await connection.query(
        'UPDATE ratings SET rating = ? WHERE user_id = ? AND book_id = ?',
        [rating, user_id, book_id]
      );
    } else {
      // Add new rating
      await connection.query(
        'INSERT INTO ratings (user_id, book_id, rating) VALUES (?, ?, ?)',
        [user_id, book_id, rating]
      );
    }

    connection.release();
    res.json({ message: 'Rating saved' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to save rating' });
  }
});

// GET USER RATINGS
router.get('/user', authMiddleware, async (req, res) => {
  try {
    const { id: user_id } = req.user;
    const connection = await pool.getConnection();
    const [ratings] = await connection.query(
      'SELECT book_id, rating FROM ratings WHERE user_id = ?',
      [user_id]
    );
    connection.release();
    res.json(ratings);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch ratings' });
  }
});

module.exports = router;
