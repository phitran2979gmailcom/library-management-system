
CREATE OR REPLACE FUNCTION update_stock_on_loan()
RETURNS TRIGGER AS $$
BEGIN
  
    IF (SELECT available_copies FROM books
        WHERE book_ID = NEW.book_ID
        FOR UPDATE) <= 0 
		THEN
        	RAISE EXCEPTION 'No available copies for book ID %', NEW.book_ID;
    END IF;
    UPDATE books SET available_copies = available_copies - 1
    WHERE book_ID = NEW.book_ID;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_update_stock_on_loan
BEFORE INSERT ON loans
FOR EACH ROW EXECUTE FUNCTION update_stock_on_loan();


CREATE OR REPLACE FUNCTION update_stock_on_return()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.return_date IS NULL AND NEW.return_date IS NOT NULL
	THEN
        UPDATE books SET available_copies = available_copies + 1
        WHERE book_ID = NEW.book_ID
        AND available_copies < total_copies;  
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_update_stock_on_return
BEFORE UPDATE ON loans
FOR EACH ROW EXECUTE FUNCTION update_stock_on_return();


CREATE OR REPLACE FUNCTION log_loan_created()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO loan_logs (loan_id, action)
    VALUES (NEW.loan_ID, 'LOAN_CREATED');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_log_loan_created
AFTER INSERT ON loans
FOR EACH ROW EXECUTE FUNCTION log_loan_created();


CREATE OR REPLACE FUNCTION log_book_returned()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.return_date IS NULL AND NEW.return_date IS NOT NULL
	THEN
        INSERT INTO loan_logs (loan_id, action)
        VALUES (NEW.loan_ID, 'BOOK_RETURNED');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_log_book_returned
AFTER UPDATE ON loans
FOR EACH ROW EXECUTE FUNCTION log_book_returned();
