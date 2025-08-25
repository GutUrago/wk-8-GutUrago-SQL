-- Library Management System Database Schema

-- Database: `library_db`
-- DROP DATABASE IF EXISTS `library_db`;
-- CREATE DATABASE `library_db`;
-- USE `library_db`;

-- --------------------------------------------------------

-- Table `Authors`
-- Stores information about the authors of books.
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    biography TEXT,
    -- Ensure combination of first and last name is unique for an author
    UNIQUE (first_name, last_name)
);

-- --------------------------------------------------------

-- Table `Publishers`
-- Stores information about the publishers of books.
CREATE TABLE Publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(255) NOT NULL UNIQUE,
    address VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255) UNIQUE
);

-- --------------------------------------------------------

-- Table `Books`
-- Stores information about the books in the library.
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(13) NOT NULL UNIQUE, -- International Standard Book Number
    title VARCHAR(255) NOT NULL,
    publication_year YEAR,
    genre VARCHAR(100),
    num_copies_total INT NOT NULL DEFAULT 1 CHECK (num_copies_total >= 0),
    num_copies_available INT NOT NULL DEFAULT 1 CHECK (num_copies_available >= 0),
    publisher_id INT,
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id)
        ON UPDATE CASCADE -- If a publisher_id changes, update references in Books
        ON DELETE RESTRICT -- Prevent deleting a publisher if books are associated with it
);

-- --------------------------------------------------------

-- Table `BookAuthors`
-- Junction table for the Many-to-Many relationship between Books and Authors.
-- A book can have multiple authors, and an author can write multiple books.
CREATE TABLE BookAuthors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id), -- Composite primary key
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE, -- If a book is deleted, remove its author associations
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE  -- If an author is deleted, remove their book associations
);

-- --------------------------------------------------------

-- Table `Members`
-- Stores information about library members.
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255) NOT NULL UNIQUE,
    registration_date DATE NOT NULL DEFAULT (CURRENT_DATE)
);

-- --------------------------------------------------------

-- Table `Loans`
-- Stores information about books loaned out to members.
CREATE TABLE Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,
    return_date DATE, -- NULL if not yet returned
    status ENUM('borrowed', 'returned', 'overdue', 'lost') NOT NULL DEFAULT 'borrowed',
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT, -- Prevent deleting a book if it's currently on loan
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT, -- Prevent deleting a member if they have active loans
    -- Constraint to ensure return_date is not before loan_date
    CHECK (return_date IS NULL OR return_date >= loan_date),
    -- Constraint to ensure due_date is not before loan_date
    CHECK (due_date >= loan_date)
);
