const express = require('express');
const router = express.Router();
const pool = require('../config/database');
const authMiddleware = require('../middleware/auth');

// GET ALL BOOKS
router.get('/', async (req, res) => {
  try {
    const connection = await pool.getConnection();
    const [books] = await connection.query(`
      SELECT b.*, c.name as category_name, 
             COALESCE(AVG(r.rating), 0) as average_rating
      FROM books b
      LEFT JOIN categories c ON b.category_id = c.id
      LEFT JOIN ratings r ON b.id = r.book_id
      GROUP BY b.id
      ORDER BY b.id
    `);
    connection.release();
    res.json(books);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch books' });
  }
});

// GET BOOKS BY CATEGORY
router.get('/category/:category_id', async (req, res) => {
  try {
    const { category_id } = req.params;
    const connection = await pool.getConnection();
    const [books] = await connection.query(`
      SELECT b.*, c.name as category_name,
             COALESCE(AVG(r.rating), 0) as average_rating
      FROM books b
      LEFT JOIN categories c ON b.category_id = c.id
      LEFT JOIN ratings r ON b.id = r.book_id
      WHERE b.category_id = ?
      GROUP BY b.id
    `, [category_id]);
    connection.release();
    res.json(books);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch books' });
  }
});

// GET SINGLE BOOK
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const connection = await pool.getConnection();
    const [books] = await connection.query(`
      SELECT b.*, c.name as category_name,
             COALESCE(AVG(r.rating), 0) as average_rating
      FROM books b
      LEFT JOIN categories c ON b.category_id = c.id
      LEFT JOIN ratings r ON b.id = r.book_id
      WHERE b.id = ?
      GROUP BY b.id
    `, [id]);
    connection.release();
    
    if (books.length === 0) {
      return res.status(404).json({ error: 'Book not found' });
    }
    res.json(books[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch book' });
  }
});

// SEARCH BOOKS
router.get('/search/:query', async (req, res) => {
  try {
    const { query } = req.params;
    const connection = await pool.getConnection();
    const [books] = await connection.query(`
      SELECT b.*, c.name as category_name,
             COALESCE(AVG(r.rating), 0) as average_rating
      FROM books b
      LEFT JOIN categories c ON b.category_id = c.id
      LEFT JOIN ratings r ON b.id = r.book_id
      WHERE b.title LIKE ? OR b.author LIKE ?
      GROUP BY b.id
    `, [`%${query}%`, `%${query}%`]);
    connection.release();
    res.json(books);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Search failed' });
  }
});

module.exports = router;
