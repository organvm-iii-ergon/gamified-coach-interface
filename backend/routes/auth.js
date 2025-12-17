const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const authController = require('../controllers/authController');
const { authenticate } = require('../middleware/auth');
const { authLimiter } = require('../middleware/rateLimiters');

// Validation chains
const registerValidation = [
  body('email').isEmail().withMessage('Invalid email format').normalizeEmail(),
  body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters'),
  body('username')
    .trim()
    .isLength({ min: 3 }).withMessage('Username must be at least 3 characters')
    .matches(/^[a-zA-Z0-9_]+$/).withMessage('Username can only contain letters, numbers, and underscores')
];

const loginValidation = [
  body('email').isEmail().withMessage('Invalid email format').normalizeEmail(),
  body('password').exists().withMessage('Password is required')
];

// Public routes
router.post('/register', authLimiter, registerValidation, authController.register);
router.post('/login', authLimiter, loginValidation, authController.login);
router.post('/refresh', authController.refreshToken);

// Protected routes
router.get('/me', authenticate, authController.getMe);
router.post('/logout', authenticate, authController.logout);
router.put('/password', authenticate, authController.changePassword);

module.exports = router;
