<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,java.math.BigDecimal,com.expense.model.*,java.text.NumberFormat,java.util.Locale" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<Expense> expenses   = (List<Expense>) request.getAttribute("expenses");
    List<Category> categories = (List<Category>) request.getAttribute("categories");

    NumberFormat nf = NumberFormat.getInstance(new Locale("en","IN"));
    nf.setMaximumFractionDigits(0);

    BigDecimal total = BigDecimal.ZERO;
    if (expenses != null) for (Expense e : expenses) total = total.add(e.getAmount());

    String success = request.getParameter("success");
    String fm = (String) request.getAttribute("filterMonth");
    String fy = (String) request.getAttribute("filterYear");
    String fc = (String) request.getAttribute("filterCategoryId");
    String fs = (String) request.getAttribute("filterSearch");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expenses — SpendWise</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="sidebar.jsp" %>

    <main class="main-content">
        <div class="page-header">
            <div>
                <p class="breadcrumb">TRANSACTIONS</p>
                <h1>All Expenses</h1>
            </div>
            <a href="<%= request.getContextPath() %>/expenses?action=add" class="btn btn-primary">+ Add Expense</a>
        </div>

        <% if ("added".equals(success)) { %><div class="alert alert-success">✓ Expense added successfully!</div><% } %>
        <% if ("updated".equals(success)) { %><div class="alert alert-success">✓ Expense updated!</div><% } %>
        <% if ("deleted".equals(success)) { %><div class="alert alert-error">🗑 Expense deleted.</div><% } %>

        <!-- Filter Bar -->
        <form method="GET" action="<%= request.getContextPath() %>/expenses" style="margin-bottom:1.5rem;">
            <div class="filter-bar">
                <div class="form-group">
                    <label>Month</label>
                    <select name="month" style="width:130px;">
                        <option value="">All months</option>
                        <% String[] mons = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
                           for (int i = 1; i <= 12; i++) { %>
                        <option value="<%= i %>" <%= String.valueOf(i).equals(fm) ? "selected" : "" %>><%= mons[i-1] %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Year</label>
                    <select name="year" style="width:100px;">
                        <option value="">All years</option>
                        <% int cy = java.time.LocalDate.now().getYear();
                           for (int y = cy; y >= cy - 3; y--) { %>
                        <option value="<%= y %>" <%= String.valueOf(y).equals(fy) ? "selected" : "" %>><%= y %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Category</label>
                    <select name="categoryId" style="width:170px;">
                        <option value="">All categories</option>
                        <% if (categories != null) { for (Category cat : categories) { %>
                        <option value="<%= cat.getId() %>" <%= String.valueOf(cat.getId()).equals(fc) ? "selected" : "" %>><%= cat.getIcon() %> <%= cat.getName() %></option>
                        <% } } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Search</label>
                    <input type="text" name="search" placeholder="Search title..." value="<%= fs != null ? fs : "" %>" style="width:200px;">
                </div>
                <div class="form-group" style="display:flex;gap:0.5rem;">
                    <button type="submit" class="btn btn-primary btn-sm">Filter</button>
                    <a href="<%= request.getContextPath() %>/expenses" class="btn btn-ghost btn-sm">Clear</a>
                </div>
            </div>
        </form>

        <!-- Summary Bar -->
        <% if (expenses != null && !expenses.isEmpty()) { %>
        <div style="display:flex;align-items:center;gap:1rem;margin-bottom:1rem;padding:0.75rem 1rem;background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-sm);">
            <span style="color:var(--text-3);font-size:0.82rem;font-family:var(--font-mono);">
                SHOWING <%= expenses.size() %> TRANSACTIONS
            </span>
            <span style="margin-left:auto;font-family:var(--font-mono);font-weight:600;color:var(--coral);">
                Total: ₹<%= nf.format(total) %>
            </span>
        </div>
        <% } %>

        <!-- Table -->
        <div class="card" style="padding:0;">
            <% if (expenses != null && !expenses.isEmpty()) { %>
            <table class="expense-table">
                <thead>
                    <tr>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Date</th>
                        <th>Method</th>
                        <th>Notes</th>
                        <th style="text-align:right;">Amount</th>
                        <th style="text-align:center;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Expense exp : expenses) { %>
                <tr class="expense-row">
                    <td style="font-weight:500;max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                        <%= exp.getTitle() %>
                    </td>
                    <td>
                        <span class="cat-badge"
                              style="background:<%= exp.getCategoryColor() %>22;color:<%= exp.getCategoryColor() %>;">
                            <%= exp.getCategoryIcon() %> <%= exp.getCategoryName() %>
                        </span>
                    </td>
                    <td style="color:var(--text-2);font-family:var(--font-mono);font-size:0.82rem;">
                        <%= exp.getExpenseDate() %>
                    </td>
                    <td><span class="payment-pill"><%= exp.getPaymentMethod() %></span></td>
                    <td style="color:var(--text-3);font-size:0.8rem;max-width:140px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                        <%= exp.getNotes() != null && !exp.getNotes().isEmpty() ? exp.getNotes() : "—" %>
                    </td>
                    <td style="text-align:right;" class="amount-cell">₹<%= nf.format(exp.getAmount()) %></td>
                    <td style="text-align:center;">
                        <div style="display:flex;gap:0.4rem;justify-content:center;">
                            <a href="<%= request.getContextPath() %>/expenses?action=edit&id=<%= exp.getId() %>"
                               class="btn btn-ghost btn-sm" title="Edit">✏</a>
                            <a href="<%= request.getContextPath() %>/expenses?action=delete&id=<%= exp.getId() %>"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Delete this expense?')" title="Delete">🗑</a>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="empty-state">
                <div class="empty-icon">💸</div>
                <h3>No expenses found</h3>
                <p>Try adjusting your filters or add a new expense.</p>
            </div>
            <% } %>
        </div>
    </main>
</div>
</body>
</html>
