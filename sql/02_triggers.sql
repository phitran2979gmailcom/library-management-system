CREATE OR REPLACE FUNCTION update_stock_on_loan ()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT available_copies FROM books
		WHERE book_ID = NEW.book_ID) <= 0 
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
        WHERE book_ID = NEW.book_ID;
    END IF;
    RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_stock_on_return
BEFORE UPDATE ON loans
FOR EACH ROW EXECUTE FUNCTION update_stock_on_return();
