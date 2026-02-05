const express = require('express');
const router = express.Router();
const pool = require('../config/database');
const authMiddleware = require('../middleware/auth');

// GET USER CART
router.get('/', authMiddleware, async (req, res) => {
  try {
    const { id: user_id } = req.user;
    const connection = await pool.getConnection();
    const [cartItems] = await connection.query(`
      SELECT c.*, b.title, b.price, b.image_url
      FROM cart c
      JOIN books b ON c.book_id = b.id
      WHERE c.user_id = ?
    `, [user_id]);
    connection.release();
    res.json(cartItems);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch cart' });
  }
});

// ADD TO CART
router.post('/add', authMiddleware, async (req, res) => {
  try {
    const { book_id, quantity = 1 } = req.body;
    const { id: user_id } = req.user;

    if (!book_id) {
      return res.status(400).json({ error: 'Book ID required' });
    }

    const connection = await pool.getConnection();

    // Check if book exists
    const [book] = await connection.query('SELECT id FROM books WHERE id = ?', [book_id]);
    if (book.length === 0) {
      connection.release();
      return res.status(404).json({ error: 'Book not found' });
    }

    // Check if already in cart
    const [existing] = await connection.query(
      'SELECT id, quantity FROM cart WHERE user_id = ? AND book_id = ?',
      [user_id, book_id]
    );

    if (existing.length > 0) {
      // Update quantity
      await connection.query(
        'UPDATE cart SET quantity = quantity + ? WHERE user_id = ? AND book_id = ?',
        [quantity, user_id, book_id]
      );
    } else {
      // Add new item
      await connection.query(
        'INSERT INTO cart (user_id, book_id, quantity) VALUES (?, ?, ?)',
        [user_id, book_id, quantity]
      );
    }

    connection.release();
    res.json({ message: 'Added to cart' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to add to cart' });
  }
});

// UPDATE CART QUANTITY
router.put('/update/:cart_id', authMiddleware, async (req, res) => {
  try {
    const { cart_id } = req.params;
    const { quantity } = req.body;
    const { id: user_id } = req.user;

    if (!quantity || quantity < 1) {
      return res.status(400).json({ error: 'Invalid quantity' });
    }

    const connection = await pool.getConnection();
    const [result] = await connection.query(
      'UPDATE cart SET quantity = ? WHERE id = ? AND user_id = ?',
      [quantity, cart_id, user_id]
    );

    connection.release();
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Cart item not found' });
    }
    res.json({ message: 'Cart updated' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to update cart' });
  }
});

// REMOVE FROM CART
router.delete('/remove/:cart_id', authMiddleware, async (req, res) => {
  try {
    const { cart_id } = req.params;
    const { id: user_id } = req.user;

    const connection = await pool.getConnection();
    const [result] = await connection.query(
      'DELETE FROM cart WHERE id = ? AND user_id = ?',
      [cart_id, user_id]
    );

    connection.release();
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Cart item not found' });
    }
    res.json({ message: 'Removed from cart' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to remove from cart' });
  }
});

// CLEAR CART
router.delete('/clear', authMiddleware, async (req, res) => {
  try {
    const { id: user_id } = req.user;
    const connection = await pool.getConnection();
    await connection.query('DELETE FROM cart WHERE user_id = ?', [user_id]);
    connection.release();
    res.json({ message: 'Cart cleared' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to clear cart' });
  }
});

module.exports = router;
