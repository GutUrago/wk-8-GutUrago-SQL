# Library Management System Database

## Project Title
Library Management System Database

## Description
This project implements a relational database schema for a simple Library Management System using MySQL. The database is designed to keep track of books, their authors and publishers, library members, and the lending (loan) of books to members. It adheres to principles of database normalization (up to 3NF) to minimize data redundancy and ensure data integrity.

### Key Features:
-   **Book Management**: Store details about books including ISBN, title, publication year, genre, and inventory counts.
-   **Author Management**: Keep records of authors with their personal details.
-   **Publisher Management**: Maintain information about publishing houses.
-   **Member Management**: Store details of library members.
-   **Loan Tracking**: Record book borrowing and return dates, along with loan status.
-   **Relationships**: Establishes one-to-many (e.g., Publisher to Books, Member to Loans) and many-to-many (e.g., Books to Authors) relationships.

## How to Run/Setup the Project (or Import SQL)

To set up this database on your local MySQL environment, follow these steps:

1.  **Install MySQL**: Ensure you have MySQL Server installed and running on your system (e.g., using MySQL Workbench, XAMPP, or a direct MySQL installation).
2.  **Create a Database (Optional but Recommended)**: You can optionally create a new database named `library_db` (or any other name you prefer).
    ```sql
    CREATE DATABASE library_db;
    USE library_db;
    ```
    (Note: The provided SQL script can also create the database if you uncomment the `DROP DATABASE` and `CREATE DATABASE` lines at the top.)
3.  **Execute the SQL Script**:
    * Open your MySQL client (e.g., MySQL Workbench, command-line client).
    * Connect to your MySQL server.
    * Execute the entire content of the `library_management_system.sql` file. This will create all the necessary tables and define their relationships and constraints.

    **Using MySQL Workbench:**
    * Go to `File > Open SQL Script...` and select your `library_management_system.sql` file.
    * Ensure the correct schema (`library_db` if you created it, or create a new one) is selected in the Navigator panel on the left.
    * Click the "Execute" button (the lightning bolt icon) to run the script.

    **Using MySQL Command Line:**
    ```bash
    mysql -u your_username -p library_db < library_management_system.sql
    ```
    (Replace `your_username` with your MySQL username and enter your password when prompted.)

## Entity-Relationship Diagram (ERD)
Here's a conceptual overview of the database schema and its relationships. (A tool like MySQL Workbench's reverse engineering feature can generate a visual ERD from the SQL script.)

**Entities and Relationships:**

-   **`Authors`**
    -   `author_id` (PK)
    -   `first_name`
    -   `last_name`
    -   `biography`
-   **`Publishers`**
    -   `publisher_id` (PK)
    -   `publisher_name`
    -   `address`
    -   `phone`
    -   `email`
-   **`Books`**
    -   `book_id` (PK)
    -   `isbn` (Unique)
    -   `title`
    -   `publication_year`
    -   `genre`
    -   `num_copies_total`
    -   `num_copies_available`
    -   `publisher_id` (FK to `Publishers`)
-   **`Members`**
    -   `member_id` (PK)
    -   `first_name`
    -   `last_name`
    -   `address`
    -   `phone`
    -   `email` (Unique)
    -   `registration_date`
-   **`Loans`**
    -   `loan_id` (PK)
    -   `book_id` (FK to `Books`)
    -   `member_id` (FK to `Members`)
    -   `loan_date`
    -   `due_date`
    -   `return_date`
    -   `status`
-   **`BookAuthors` (Junction Table)**
    -   `book_id` (FK to `Books`, part of Composite PK)
    -   `author_id` (FK to `Authors`, part of Composite PK)

**Relationships:**
-   `Authors` *many-to-many* `Books` (via `BookAuthors`)
-   `Publishers` *one-to-many* `Books`
-   `Members` *one-to-many* `Loans`
-   `Books` *one-to-many* `Loans`

