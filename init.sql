CREATE TABLE IF NOT EXISTS students (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    age INTEGER
);

INSERT INTO students (id, name, email, age) VALUES
    (1, 'Nguyen Van A', 'vana@example.com', 20),
    (2, 'Tran Thi B', 'thib@example.com', 21),
    (3, 'Le Van C', 'vanc@example.com', 22),
    (4, 'Pham Thi D', 'thid@example.com', 20),
    (5, 'Hoang Van E', 'vane@example.com', 23),
    (6, 'Do Thi F', 'thif@example.com', 17),
    (7, 'Bui Van G', 'vang@example.com', 24),
    (8, 'Dang Thi H', 'thih@example.com', 22),
    (9, 'Ngo Van I', 'vani@example.com', 20),
    (10, 'Vu Thi K', 'thik@example.com', 16),
    (11, 'Phan Van L', 'vanl@example.com', 21),
    (12, 'Truong Thi M', 'thim@example.com', 22)
ON CONFLICT (id) DO NOTHING;
