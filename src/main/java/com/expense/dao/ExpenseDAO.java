package com.expense.dao;

import com.expense.model.Category;
import com.expense.model.Expense;
import com.expense.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExpenseDAO {

    // ─── Categories ───────────────────────────────────────────────────────────

    public List<Category> getCategories(int userId) throws SQLException {
        String sql = "SELECT * FROM categories WHERE is_default = TRUE OR user_id = ? ORDER BY name";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            List<Category> list = new ArrayList<>();
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setIcon(rs.getString("icon"));
                c.setColor(rs.getString("color"));
                list.add(c);
            }
            return list;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ─── Expenses CRUD ────────────────────────────────────────────────────────

    public void addExpense(Expense e) throws SQLException {
        String sql = "INSERT INTO expenses (user_id, category_id, title, amount, expense_date, notes, payment_method) VALUES (?,?,?,?,?,?,?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, e.getUserId());
            ps.setInt(2, e.getCategoryId());
            ps.setString(3, e.getTitle());
            ps.setBigDecimal(4, e.getAmount());
            ps.setDate(5, e.getExpenseDate());
            ps.setString(6, e.getNotes());
            ps.setString(7, e.getPaymentMethod());
            ps.executeUpdate();
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public void updateExpense(Expense e) throws SQLException {
        String sql = "UPDATE expenses SET category_id=?, title=?, amount=?, expense_date=?, notes=?, payment_method=? WHERE id=? AND user_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, e.getCategoryId());
            ps.setString(2, e.getTitle());
            ps.setBigDecimal(3, e.getAmount());
            ps.setDate(4, e.getExpenseDate());
            ps.setString(5, e.getNotes());
            ps.setString(6, e.getPaymentMethod());
            ps.setInt(7, e.getId());
            ps.setInt(8, e.getUserId());
            ps.executeUpdate();
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public void deleteExpense(int id, int userId) throws SQLException {
        String sql = "DELETE FROM expenses WHERE id=? AND user_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public Expense getExpenseById(int id, int userId) throws SQLException {
        String sql = "SELECT e.*, c.name as cat_name, c.icon as cat_icon, c.color as cat_color " +
                     "FROM expenses e JOIN categories c ON e.category_id = c.id " +
                     "WHERE e.id=? AND e.user_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapExpense(rs);
            return null;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public List<Expense> getExpenses(int userId, String month, String year,
                                     String categoryId, String search) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT e.*, c.name as cat_name, c.icon as cat_icon, c.color as cat_color " +
            "FROM expenses e JOIN categories c ON e.category_id = c.id " +
            "WHERE e.user_id = ?");

        List<Object> params = new ArrayList<>();
        params.add(userId);

        if (month != null && !month.isEmpty()) {
            sql.append(" AND MONTH(e.expense_date) = ?");
            params.add(Integer.parseInt(month));
        }
        if (year != null && !year.isEmpty()) {
            sql.append(" AND YEAR(e.expense_date) = ?");
            params.add(Integer.parseInt(year));
        }
        if (categoryId != null && !categoryId.isEmpty()) {
            sql.append(" AND e.category_id = ?");
            params.add(Integer.parseInt(categoryId));
        }
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (e.title LIKE ? OR e.notes LIKE ?)");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        sql.append(" ORDER BY e.expense_date DESC, e.created_at DESC");

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            List<Expense> list = new ArrayList<>();
            while (rs.next()) list.add(mapExpense(rs));
            return list;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ─── Dashboard Stats ──────────────────────────────────────────────────────

    public BigDecimal getTotalByMonth(int userId, int month, int year) throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount),0) FROM expenses WHERE user_id=? AND MONTH(expense_date)=? AND YEAR(expense_date)=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId); ps.setInt(2, month); ps.setInt(3, year);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public List<Object[]> getCategoryBreakdown(int userId, int month, int year) throws SQLException {
        String sql = "SELECT c.name, c.icon, c.color, COALESCE(SUM(e.amount),0) as total " +
                     "FROM expenses e JOIN categories c ON e.category_id = c.id " +
                     "WHERE e.user_id=? AND MONTH(e.expense_date)=? AND YEAR(e.expense_date)=? " +
                     "GROUP BY c.id ORDER BY total DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId); ps.setInt(2, month); ps.setInt(3, year);
            ResultSet rs = ps.executeQuery();
            List<Object[]> list = new ArrayList<>();
            while (rs.next()) {
                list.add(new Object[]{rs.getString("name"), rs.getString("icon"),
                                      rs.getString("color"), rs.getBigDecimal("total")});
            }
            return list;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public List<Object[]> getLast6MonthsTrend(int userId) throws SQLException {
        String sql = "SELECT YEAR(expense_date) as yr, MONTH(expense_date) as mo, " +
                     "COALESCE(SUM(amount),0) as total " +
                     "FROM expenses WHERE user_id=? AND expense_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) " +
                     "GROUP BY yr, mo ORDER BY yr, mo";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            List<Object[]> list = new ArrayList<>();
            while (rs.next()) {
                list.add(new Object[]{rs.getInt("yr"), rs.getInt("mo"), rs.getBigDecimal("total")});
            }
            return list;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public List<Expense> getRecentExpenses(int userId, int limit) throws SQLException {
        String sql = "SELECT e.*, c.name as cat_name, c.icon as cat_icon, c.color as cat_color " +
                     "FROM expenses e JOIN categories c ON e.category_id = c.id " +
                     "WHERE e.user_id=? ORDER BY e.expense_date DESC, e.created_at DESC LIMIT ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId); ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            List<Expense> list = new ArrayList<>();
            while (rs.next()) list.add(mapExpense(rs));
            return list;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ─── Helper ───────────────────────────────────────────────────────────────

    private Expense mapExpense(ResultSet rs) throws SQLException {
        Expense e = new Expense();
        e.setId(rs.getInt("id"));
        e.setUserId(rs.getInt("user_id"));
        e.setCategoryId(rs.getInt("category_id"));
        e.setCategoryName(rs.getString("cat_name"));
        e.setCategoryIcon(rs.getString("cat_icon"));
        e.setCategoryColor(rs.getString("cat_color"));
        e.setTitle(rs.getString("title"));
        e.setAmount(rs.getBigDecimal("amount"));
        e.setExpenseDate(rs.getDate("expense_date"));
        e.setNotes(rs.getString("notes"));
        e.setPaymentMethod(rs.getString("payment_method"));
        e.setCreatedAt(rs.getTimestamp("created_at"));
        return e;
    }
}
