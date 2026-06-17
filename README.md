# 💸 SpendWise — Expense Tracker

A full-stack expense tracking web application built with **JSP**, **Servlet**, and **MySQL**,
featuring a dark glassmorphism UI with real-time charts.

---

## ✨ Features

| Feature | Details |
|---|---|
| 🔐 Authentication | Register & login with BCrypt-hashed passwords |
| 💰 Expense CRUD | Add, edit, delete, and filter expenses |
| 📊 Dashboard | Monthly totals, 6-month trend chart, donut chart by category |
| 🗂 Categories | 10 built-in categories (Food, Travel, Health, etc.) |
| 💳 Payment Methods | Cash, Card, UPI, Net Banking |
| 🔍 Filters | By month, year, category, and keyword search |
| 📱 Responsive | Works on mobile and desktop |

---

## 🛠 Tech Stack

- **Backend**: Java Servlets + JSP (Jakarta EE 5)
- **Database**: MySQL 8+
- **Build**: Maven
- **Server**: Apache Tomcat 10+
- **Libraries**: BCrypt, Gson, Chart.js (CDN), JSTL

---

## 🚀 Setup Instructions

### 1. Prerequisites
- Java 11+
- Maven 3.6+
- MySQL 8+
- Apache Tomcat 10+

### 2. Database Setup
```bash
mysql -u root -p < sql/schema.sql
```

### 3. Configure DB Connection
Edit `src/main/java/com/expense/util/DBConnection.java`:
```java
private static final String URL      = "jdbc:mysql://localhost:3306/expense_tracker?...";
private static final String USERNAME = "root";
private static final String PASSWORD = "your_actual_password";
```

### 4. Build
```bash
mvn clean package
```

### 5. Deploy
Copy `target/ExpenseTracker.war` to Tomcat's `webapps/` folder, then:
```bash
$TOMCAT_HOME/bin/startup.sh     # Linux/macOS
$TOMCAT_HOME\bin\startup.bat    # Windows
```

### 6. Access
Open: `http://localhost:8080/ExpenseTracker/`

---

## 📁 Project Structure

```
ExpenseTracker/
├── pom.xml
├── sql/
│   └── schema.sql                   ← DB schema & seed data
└── src/main/
    ├── java/com/expense/
    │   ├── model/                   ← User, Expense, Category POJOs
    │   │   ├── User.java
    │   │   ├── Expense.java
    │   │   └── Category.java
    │   ├── dao/                     ← Database access layer
    │   │   ├── UserDAO.java
    │   │   └── ExpenseDAO.java
    │   ├── servlet/                 ← HTTP request handlers
    │   │   ├── AuthServlet.java     ← /auth (login/register/logout)
    │   │   ├── DashboardServlet.java← /dashboard
    │   │   └── ExpenseServlet.java  ← /expenses (CRUD)
    │   └── util/
    │       └── DBConnection.java    ← MySQL connection pool
    └── webapp/
        ├── index.jsp                ← Redirect to dashboard/login
        ├── login.jsp                ← Login page
        ├── register.jsp             ← Register page
        ├── css/
        │   └── style.css            ← Dark glassmorphism theme
        └── WEB-INF/
            ├── web.xml
            ├── sidebar.jsp          ← Reusable sidebar partial
            ├── dashboard.jsp        ← Dashboard view
            ├── expenses.jsp         ← Expenses list view
            ├── expense-form.jsp     ← Add/Edit form
            └── error.jsp            ← 404 page
```

---

## 🎨 UI Design

- **Theme**: Dark void background with glassmorphism cards
- **Fonts**: Syne (display) + DM Mono (data/labels)
- **Accent**: Purple `#7c6af5` with teal/coral accents
- **Charts**: Chart.js — line trend + doughnut breakdown

---

## 🔐 Security

- Passwords hashed with **BCrypt** (never stored as plaintext)
- Session-based auth with 1-hour timeout
- SQL injection prevention via **PreparedStatements**
- Expenses scoped by `user_id` (users can't see each other's data)
