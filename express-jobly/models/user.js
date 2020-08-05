const db = require('../db');
const ExpressError = require('../helpers/expressError');
const { BCRYPT_WORK_FACTOR } = require('../config');
const bcrypt = require('bcrypt');

class User {
	constructor({ username, first_name, last_name, email, photo_url, is_admin }) {
		(this.username = username),
			(this.first_name = first_name),
			(this.last_name = last_name),
			(this.email = email),
			(this.photo_url = photo_url || null),
			(this.is_admin = is_admin || false);
	}

	/** find all companies. */

	static async all(query) {
		const results = await db.query(
			'SELECT username, first_name, last_name, email, is_admin FROM users ORDER BY username, last_name'
		);

		if (results.length === 0) {
			throw new ExpressError('No users found', 404);
		}

		return results.rows.map((u) => new User(u));
	}

	/** get company by handle. */

	static async get(username) {
		const results = await db.query(
			`SELECT username, first_name, last_name, email, photo_url, is_admin FROM users WHERE username = $1`,
			[ username ]
		);

		const user = results.rows[0];

		if (user === undefined) {
			throw new ExpressError(`No user found with username: ${username}`, 404);
		}

		return new User(user);
	}

	static async register(data) {
		const hashedPassword = await bcrypt.hash(data.password, BCRYPT_WORK_FACTOR);

		const result = await db.query(
			`INSERT INTO users (
                username, password, first_name, last_name, email, photo_url) 
         VALUES ($1, $2, $3, $4, $5, $6) 
         RETURNING username, first_name, last_name, email, photo_url`,
			[ data.username, hashedPassword, data.first_name, data.last_name, data.email, data.photo_url ]
		);

		return result.rows[0];
	}

	/** save updated information about a company. */

	static async save(query, values) {
		const result = await db.query(`${query}`, [ ...values ]);
		console.log(result.rows[0]);
		delete result.rows[0].password;
		return result.rows[0];
	}

	/** Delete a company */

	static async delete(username) {
		const result = await db.query('DELETE FROM users WHERE username = $1 RETURNING *', [ username ]);

		if (result.rows.length === 0) {
			throw new ExpressError(`No user found with username: ${username}. Could not delete.`, 404);
		}

		return result.rows[0];
	}

	static async authenticate(data) {
		const results = await db.query(
			`
					SELECT username, password, is_admin 
					FROM users WHERE username = $1`,
			[ data.username ]
		);

		const user = results.rows[0];

		if (user) {
			const validUser = await bcrypt.compare(data.password, user.password);
			if (validUser) {
				return user;
			} else {
				throw new ExpressError(`Incorrect password`, 401);
			}
		} else {
			throw new ExpressError(`No user exists with username ${data.username}`, 404);
		}
	}
}

module.exports = User;
