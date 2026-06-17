-- =============================================
-- Expense Tracker Database Schema
-- =============================================

CREATE DATABASE IF NOT EXISTS expense_tracker;
USE expense_tracker;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    icon VARCHAR(10) DEFAULT '📦',
    color VARCHAR(7) DEFAULT '#6366f1',
    user_id INT,
    is_default BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Expenses table
CREATE TABLE IF NOT EXISTS expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    expense_date DATE NOT NULL,
    notes TEXT,
    payment_method ENUM('cash','card','upi','netbanking','other') DEFAULT 'cash',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Budget table
CREATE TABLE IF NOT EXISTS budgets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_id INT,
    monthly_limit DECIMAL(12,2) NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- Default categories (global)
INSERT INTO categories (name, icon, color, is_default) VALUES
('Food & Dining', '🍔', '#f97316', TRUE),
('Transportation', '🚗', '#3b82f6', TRUE),
('Shopping', '🛍️', '#ec4899', TRUE),
('Entertainment', '🎬', '#8b5cf6', TRUE),
('Healthcare', '💊', '#10b981', TRUE),
('Utilities', '💡', '#f59e0b', TRUE),
('Education', '📚', '#6366f1', TRUE),
('Travel', '✈️', '#14b8a6', TRUE),
('Rent & Housing', '🏠', '#ef4444', TRUE),
('Other', '📦', '#6b7280', TRUE);
