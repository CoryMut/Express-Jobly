const User = require('../models/user');
const ExpressError = require('../helpers/expressError');
const { SECRET_KEY } = require('../config');
const jwt = require('jsonwebtoken');

function checkForToken(req) {
	if (!req.body._token && !req.query._token) {
		throw new ExpressError(
			'No token found. Please login and attach the received token to your request as _token.',
			401
		);
	}

	const receivedToken = req.body._token || req.query._token;
	let token;
	try {
		token = jwt.verify(receivedToken, SECRET_KEY);
		return token;
	} catch (error) {
		throw new ExpressError('Invalid token. Please re-authenticate.', 401);
	}
}

async function authUser(req, res, next) {
	try {
		if (!req.body.username || !req.body.password) {
			throw new ExpressError('Missing credentials. Expecting username and password.', 400);
		} else {
			const user = await User.authenticate(req.body);
			res.locals.user = user;
			next();
		}
	} catch (error) {
		console.error(error);
		return next(error);
	}
}

function authRequired(req, res, next) {
	try {
		if (!req.body._token && !req.query._token) {
			throw new ExpressError(
				'No token found. Please login and attach the received token to your request as _token.',
				401
			);
		}

		const receivedToken = req.body._token || req.query._token;
		let token;
		try {
			token = jwt.verify(receivedToken, SECRET_KEY);
		} catch (error) {
			throw new ExpressError('Invalid token. Please re-authenticate.', 401);
		}

		res.locals.username = token.username;
		return next();
	} catch (error) {
		return next(error);
	}
}

function checkCorrectUser(req, res, next) {
	try {
		const token = checkForToken(req);
		res.locals.username = token.username;
		if (token.username === req.params.username) {
			return next();
		} else {
			throw new ExpressError('Unauthorized for this route.', 401);
		}
	} catch (error) {
		return next(error);
	}
}

function adminRequired(req, res, next) {
	try {
		const token = checkForToken(req);
		res.locals.username = token.username;
		if (token.is_admin) {
			return next();
		} else {
			throw new ExpressError('Unauthorized for this route. Must be admin.', 401);
		}
	} catch (error) {
		return next(error);
	}
}

module.exports = { authUser, authRequired, checkCorrectUser, adminRequired };
