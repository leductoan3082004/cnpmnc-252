CREATE TABLE IF NOT EXISTS students (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    age INTEGER
);

INSERT INTO students (id, name, email, age) VALUES
    ('1', 'John Doe', 'john.doe@example.com', 20),
    ('2', 'Jane Smith', 'jane.smith@example.com', 22),
    ('3', 'Michael Johnson', 'michael.johnson@example.com', 21),
    ('4', 'Emily Davis', 'emily.davis@example.com', 23),
    ('5', 'David Wilson', 'david.wilson@example.com', 19)
ON CONFLICT (id) DO NOTHING;
