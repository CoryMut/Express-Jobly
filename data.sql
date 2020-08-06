DROP DATABASE IF EXISTS jobly;
DROP DATABASE IF EXISTS jobly_test;

CREATE DATABASE jobly;
CREATE DATABASE jobly_test;

\c jobly

CREATE TABLE companies
(
    handle TEXT PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    num_employees INT,
    description TEXT,
    logo_url TEXT
);

CREATE TABLE jobs
(
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    salary FLOAT NOT NULL,
    equity FLOAT NOT NULL,
    company_handle TEXT REFERENCES companies(handle) ON DELETE CASCADE,
    date_posted TIMESTAMP
    WITHOUT time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT jobs_equity_check CHECK
    ((equity > 0)),
    CHECK
    ((equity < 1.0))

);

    CREATE TABLE users
    (
        username TEXT PRIMARY KEY,
        password TEXT NOT NULL,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        photo_url TEXT,
        is_admin BOOLEAN NOT NULL DEFAULT FALSE
    );

    CREATE TYPE state AS ENUM
    ('interested', 'applied', 'accepted', 'rejected');

    CREATE TABLE applications
    (
        username TEXT REFERENCES users(username) ON DELETE CASCADE,
        job_id INTEGER REFERENCES jobs(id) ON DELETE CASCADE,
        state state NOT NULL,
        created_at TIMESTAMP
        WITHOUT time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY
        (username, job_id)
    );

        CREATE TABLE technologies
        (
            id SERIAL PRIMARY KEY,
            technology TEXT NOT NULL UNIQUE
        );

        CREATE TABLE technologies_jobs
        (
            job_id INTEGER REFERENCES jobs(id) ON DELETE CASCADE,
            technology_id INTEGER REFERENCES technologies(id) ON DELETE CASCADE,
            PRIMARY KEY (job_id, technology_id)
        );

        CREATE TABLE technologies_users
        (
            username TEXT REFERENCES users(username) ON DELETE CASCADE,
            technology_id INTEGER REFERENCES technologies(id) ON DELETE CASCADE,
            PRIMARY KEY (username, technology_id)
        );

        INSERT INTO companies
            (handle, name, num_employees, description, logo_url)
        VALUES
            ('apple', 'Apple', 137000, 'We do not sell apples. I know, confusing.', 'https://9to5mac.com/wp-content/uploads/sites/6/2018/02/logo.jpg?quality=82&strip=all'),
            ('microsoft', 'Microsoft', 156439, 'Owners of TikTok. We also make that one operating system.', 'https://wiki.videolan.org/images/Windows-logo.jpg'),
            ('amazon', 'Amazon', 840400, 'Definitely not a monopoly. Nothing to see here.', 'https://i.pinimg.com/originals/08/5f/d8/085fd8f7819dee3b716da73d3b2de61c.jpg');

        INSERT INTO jobs
            (title, salary, equity, company_handle)
        VALUES
            ('Technician', 55000, 0.3, 'amazon'),
            ('Electrical Engineer', 150000, 0.8, 'amazon'),
            ('CFO', 120000, 0.9, 'amazon'),
            ('Accountant', 65000, 0.3, 'amazon'),
            ('Software Engineer', 110000, 0.65, 'microsoft'),
            ('Junior Software Developer', 65000, 0.23, 'microsoft'),
            ('Senior Software Developer', 85000, 0.44, 'microsoft'),
            ('Accountant', 65800.20, 0.153, 'microsoft'),
            ('Web Developer', 65000, 0.3, 'apple'),
            ('Junior Software Engineer', 65000, 0.3, 'apple'),
            ('Senior Software Developer', 95350.89, 0.55, 'apple'),
            ('Senior Marketing Manager', 110000, 0.8, 'apple');


        INSERT INTO users
            (username, password, first_name, last_name, email, photo_url, is_admin)
        VALUES
            ('FirstJoblyUser', '$2b$12$BGk58xcbZ6EQf09SnvbypeVmKgXjql1lMOIjDAhxegknIMw.ABmTu', 'Jobly', 'User', 'joblyuser@example.com', 'https://st.depositphotos.com/2218212/2938/i/950/depositphotos_29387653-stock-photo-facebook-profile.jpg', true),
            ('NotAnAdmin', '$2b$12$BGk58xcbZ6EQf09SnvbypeVmKgXjql1lMOIjDAhxegknIMw.ABmTu', 'Not', 'Admin', 'notadmin@example.com', 'https://st.depositphotos.com/2218212/2938/i/950/depositphotos_29387653-stock-photo-facebook-profile.jpg', false);

        INSERT INTO applications
            (username, job_id, state)
        VALUES
            ('FirstJoblyUser', 5, 'applied'),
            ('FirstJoblyUser', 6, 'applied'),
            ('FirstJoblyUser', 11, 'interested'),
            ('NotAnAdmin', 4, 'applied'),
            ('NotAnAdmin', 3, 'interested'),
            ('NotAnAdmin', 2, 'rejected'),
            ('NotAnAdmin', 12, 'accepted');

        INSERT INTO technologies
            (technology)
        VALUES
            ('Python'),
            ('JavaScript'),
            ('NodeJS'),
            ('PostgreSQL'),
            ('MongoDB'),
            ('Ruby'),
            ('Go'),
            ('Swift'),
            ('mySQL'),
            ('CSS/HTML'),
            ('Flask'),
            ('Express'),
            ('React');

        INSERT INTO technologies_jobs
            (job_id, technology_id)
        VALUES
            (5, 1),
            (5, 2),
            (5, 3),
            (5, 4),
            (6, 1),
            (6, 2),
            (6, 10),
            (7, 1),
            (7, 2),
            (7, 7),
            (7, 11),
            (9, 11),
            (9, 2),
            (10, 1),
            (10, 2),
            (10, 10),
            (11, 1),
            (11, 2),
            (11, 7),
            (11, 11);

        INSERT INTO technologies_users
            (username, technology_id)
        VALUES
            ('FirstJoblyUser', 1),
            ('FirstJoblyUser', 2),
            ('FirstJoblyUser', 3),
            ('FirstJoblyUser', 4),
            ('FirstJoblyUser', 10),
            ('FirstJoblyUser', 11),
            ('FirstJoblyUser', 12),
            ('NotAnAdmin', 10),
            ('NotAnAdmin', 2);

        \c jobly_test

        CREATE TABLE companies
        (
            handle TEXT PRIMARY KEY,
            name TEXT NOT NULL UNIQUE,
            num_employees INT,
            description TEXT,
            logo_url TEXT
        );

        CREATE TABLE jobs
        (
            id SERIAL PRIMARY KEY,
            title TEXT NOT NULL,
            salary FLOAT NOT NULL,
            equity FLOAT NOT NULL,
            company_handle TEXT REFERENCES companies(handle) ON DELETE CASCADE,
            date_posted TIMESTAMP
            WITHOUT time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT jobs_equity_check CHECK
            ((equity > 0)),
    CHECK
            ((equity < 1.0))

);

            CREATE TABLE users
            (
                username TEXT PRIMARY KEY,
                password TEXT NOT NULL,
                first_name TEXT NOT NULL,
                last_name TEXT NOT NULL,
                email TEXT NOT NULL UNIQUE,
                photo_url TEXT,
                is_admin BOOLEAN NOT NULL DEFAULT FALSE
            );

            CREATE TYPE state AS ENUM
            ('interested', 'applied', 'accepted', 'rejected');

            CREATE TABLE applications
            (
                username TEXT REFERENCES users(username) ON DELETE CASCADE,
                job_id INTEGER REFERENCES jobs(id) ON DELETE CASCADE,
                state state NOT NULL,
                created_at TIMESTAMP
                WITHOUT time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY
                (username, job_id)
    );

                CREATE TABLE technologies
                (
                    id SERIAL PRIMARY KEY,
                    technology TEXT NOT NULL UNIQUE
                );

                CREATE TABLE technologies_jobs
                (
                    job_id INTEGER REFERENCES jobs(id) ON DELETE CASCADE,
                    technology_id INTEGER REFERENCES technologies(id) ON DELETE CASCADE,
                    PRIMARY KEY (job_id, technology_id)
                );

                CREATE TABLE technologies_users
                (
                    username TEXT REFERENCES users(username) ON DELETE CASCADE,
                    technology_id INTEGER REFERENCES technologies(id) ON DELETE CASCADE,
                    PRIMARY KEY (username, technology_id)
                );