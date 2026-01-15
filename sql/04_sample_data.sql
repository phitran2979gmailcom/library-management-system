INSERT INTO authors (full_name)
VALUES 
('George Orwell'),
('J.K. Rowling');

INSERT INTO categories (name) 
VALUES
('Dystopian'),
('Fantasy');

INSERT INTO books (title, ISBN, publication_year, category_ID, total_copies, available_copies)
VALUES
('1984', '978-0-452-28423-4', 1949, 1, 2, 2),
('Harry Potter and the Philosopher''s Stone', '978-0-7475-3269-9', 1997, 2, 3, 3);

INSERT INTO book_authors
VALUES
(1,1),
(2,2);

INSERT INTO members (full_name, email)
VALUES
('Ali Veli', 'ali@example.com'),
('Ayşe Fatma', 'ayse@example.com');

INSERT INTO loans (book_ID, member_ID, due_date)
VALUES (1, 1, CURRENT_DATE + 14);
