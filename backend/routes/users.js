const express = require('express');
const router = express.Router();
const gamificationController = require('../controllers/gamificationController');
const { authenticate } = require('../middleware/auth');

// XP routes
router.post('/xp/award', authenticate, gamificationController.awardXP);
router.get('/xp/history', authenticate, gamificationController.getXPHistory);

// Onboarding routes
router.post('/onboarding', authenticate, gamificationController.saveOnboarding);

module.exports = router;
