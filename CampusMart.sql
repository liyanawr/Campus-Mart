-- 1. REFRESH SCHEMA
DROP TABLE ratings; DROP TABLE orders; DROP TABLE cart; DROP TABLE items; DROP TABLE categories; DROP TABLE users;

CREATE TABLE users (
    user_id INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    identification_no VARCHAR(20) NOT NULL UNIQUE,
    id_type VARCHAR(15), name VARCHAR(100) NOT NULL, password VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20), is_seller BOOLEAN DEFAULT FALSE, payment_qr VARCHAR(255),
    PRIMARY KEY (user_id)
);

CREATE TABLE categories (category_id INT NOT NULL PRIMARY KEY, category_name VARCHAR(50) NOT NULL);
INSERT INTO categories VALUES (1, 'Textbooks'), (2, 'Electronics'), (3, 'Clothing'), (4, 'Food'), (5, 'Others');

CREATE TABLE items (
    item_id INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    item_name VARCHAR(100) NOT NULL, description VARCHAR(500), price DOUBLE NOT NULL,
    status VARCHAR(20) DEFAULT 'Available', item_photo VARCHAR(255), preferred_payment VARCHAR(20), 
    date_posted DATE DEFAULT CURRENT_DATE, seller_id INT NOT NULL, category_id INT, qty INT DEFAULT 1,
    PRIMARY KEY (item_id), FOREIGN KEY (seller_id) REFERENCES users(user_id), FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE cart (
    cart_id INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    user_id INT NOT NULL, item_id INT NOT NULL, PRIMARY KEY (cart_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id), FOREIGN KEY (item_id) REFERENCES items(item_id)
);

CREATE TABLE orders (
    order_id INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    buyer_id INT NOT NULL, item_id INT NOT NULL, seller_id INT NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE, status VARCHAR(20) DEFAULT 'Pending', payment_method VARCHAR(20),
    PRIMARY KEY (order_id), FOREIGN KEY (buyer_id) REFERENCES users(user_id), FOREIGN KEY (item_id) REFERENCES items(item_id), FOREIGN KEY (seller_id) REFERENCES users(user_id)
);

CREATE TABLE ratings (
    rating_id INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    order_id INT NOT NULL UNIQUE, score INT NOT NULL, comment VARCHAR(500), PRIMARY KEY (rating_id), FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 2. INSERT 8 SCENARIO USERS (Password: 123)
INSERT INTO users (identification_no, id_type, name, password, phone_number, is_seller, payment_qr) VALUES 
('2023000111', 'STUDENT', 'Nurul Afifah', '123', '0123456789', TRUE, 'qr_afifah.png'),
('2023000222', 'STUDENT', 'Nur Tarnia', '123', '0198887776', TRUE, 'qr_tarnia.png'),
('990101141122', 'PUBLIC', 'Umairah Suhana', '123', '0112233445', TRUE, 'qr_umairah.png'),
('2023000444', 'STUDENT', 'Afrina Rasyiqah', '123', '0171122334', TRUE, 'qr_afrina.png'),
('2023000555', 'STUDENT', 'Haziq Hakim', '123', '0133445566', TRUE, 'qr_haziq.png'),
('950102103344', 'PUBLIC', 'Farhana Yasmin', '123', '0188776655', TRUE, 'qr_farhana.png'),
('2023000777', 'STUDENT', 'Harith Arif', '123', '0100998877', TRUE, 'qr_harith.png'),
('950505105566', 'PUBLIC', 'Nadiratul Liyana', '123', '0165554433', FALSE, NULL);

-- 3. INSERT 25+ VARIED ITEMS
INSERT INTO items (item_name, description, price, status, item_photo, preferred_payment, seller_id, category_id, qty) VALUES 
('Java Programming 10th Ed', 'Essential for CSC584. Clean pages.', 45.0, 'Available', 'java.jpg', 'BOTH', 1, 1, 1),
('Baju Kurung Silk Pink', 'Size S. Worn once for dinner.', 65.0, 'Available', 'kurung.jpg', 'QR', 1, 3, 1),
('Logitech Mouse M650', 'Wireless, silent clicks.', 120.0, 'Available', 'mouse.jpg', 'BOTH', 2, 2, 1),
('Calculus Notes (Sem 1)', 'Handwritten, very complete.', 15.0, 'Sold', 'notes.jpg', 'BOTH', 4, 1, 0),
('Lab Coat Size M', 'Used only 1 semester.', 30.0, 'Available', 'coat.jpg', 'COD', 3, 3, 1),
('Scientific Calculator', 'Casio standard uni model.', 70.0, 'Available', 'calc.jpg', 'BOTH', 4, 2, 1),
('iPhone Case 13', 'Transparent, shockproof.', 10.0, 'Available', 'case.jpg', 'BOTH', 1, 2, 10),
('Homemade Brownies', 'Box of 16. Fresh today.', 35.0, 'Available', 'brownies.jpg', 'BOTH', 5, 4, 5),
('Sneakers Size 8', 'Condition 9/10. Brand Adidas.', 85.0, 'Available', 'shoes.jpg', 'BOTH', 6, 3, 1),
('Study Desk Small', 'Foldable wooden desk.', 55.0, 'Available', 'desk.jpg', 'COD', 5, 5, 1),
('iPad Case Pro 11', 'Magnetic smart cover.', 30.0, 'Available', 'case.jpg', 'BOTH', 7, 2, 1),
('Portable Fan', 'USB Rechargeable fan.', 20.0, 'Available', 'fan.jpg', 'BOTH', 6, 2, 5),
('Coffee Mug', 'Ceramic, CampusMart themed.', 15.0, 'Available', 'mug.jpg', 'BOTH', 5, 5, 1),
('Mechanical Pencil Kit', 'Bundle of 10 pencils.', 5.0, 'Available', 'pencil.jpg', 'BOTH', 1, 5, 10),
('USB-C Hub 5-in-1', 'Multi-port adapter.', 45.0, 'Available', 'hub.jpg', 'QR', 2, 2, 1),
('Extension Plug 5m', '3-gang with surge protect.', 25.0, 'Available', 'plug.jpg', 'BOTH', 5, 2, 2),
('Homemade Cookies', 'Freshly baked 500g.', 22.0, 'Available', 'cookies.jpg', 'BOTH', 6, 4, 10),
('Calculus early book', 'Thomas Calculus book.', 50.0, 'Available', 'cal3.jpg', 'COD', 7, 1, 1),
('Physics Reference Book', 'Reference for Engineers.', 40.0, 'Available', 'physics.jpg', 'COD', 3, 1, 1),
('Denim Jacket L', 'Vintage look, washed.', 50.0, 'Available', 'jacket.jpg', 'COD', 6, 3, 1);

-- 4. SCENARIO ORDERS
-- Balqis (8) bought from Nurul (1)
INSERT INTO orders (buyer_id, item_id, seller_id, payment_method, status) VALUES (8, 1, 1, 'QR', 'Completed');
INSERT INTO ratings (order_id, score, comment) VALUES (1, 5, 'Fast delivery, book looks brand new!');