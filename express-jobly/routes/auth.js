const express = require('express');
const router = new express.Router();
const { makeToken } = require('../helpers/token');
const { authUser } = require('../middleware/auth');

router.post('/login', authUser, async (req, res, next) => {
	try {
		const user = res.locals.user;
		const token = makeToken(user);

		return res.json({ token });
	} catch (error) {
		return next(error);
	}
});

module.exports = router;
