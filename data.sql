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