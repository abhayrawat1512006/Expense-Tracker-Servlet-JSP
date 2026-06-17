<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,com.expense.model.*" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    Expense editExpense    = (Expense) request.getAttribute("expense");
    List<Category> cats   = (List<Category>) request.getAttribute("categories");
    boolean isEdit        = editExpense != null;
    String today          = java.time.LocalDate.now().toString();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit" : "Add" %> Expense — SpendWise</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="sidebar.jsp" %>

    <main class="main-content">
        <div class="page-header">
            <div>
                <p class="breadcrumb">EXPENSES</p>
                <h1><%= isEdit ? "✏ Edit Expense" : "➕ Add Expense" %></h1>
            </div>
            <a href="<%= request.getContextPath() %>/expenses" class="btn btn-ghost">← Back</a>
        </div>

        <div class="card form-card">
            <form action="<%= request.getContextPath() %>/expenses" method="POST">
                <input type="hidden" name="action" value="<%= isEdit ? "update" : "add" %>">
                <% if (isEdit) { %><input type="hidden" name="id" value="<%= editExpense.getId() %>"><% } %>

                <!-- Title -->
                <div class="form-group">
                    <label>Expense Title *</label>
                    <input type="text" name="title" placeholder="e.g. Lunch at Haldirams"
                           required maxlength="150"
                           value="<%= isEdit ? editExpense.getTitle() : "" %>">
                </div>

                <div class="form-grid-2">
                    <!-- Amount -->
                    <div class="form-group">
                        <label>Amount (₹) *</label>
                        <input type="number" name="amount" placeholder="0.00"
                               step="0.01" min="0.01" required
                               value="<%= isEdit ? editExpense.getAmount() : "" %>">
                    </div>

                    <!-- Date -->
                    <div class="form-group">
                        <label>Date *</label>
                        <input type="date" name="expenseDate" required
                               value="<%= isEdit ? editExpense.getExpenseDate() : today %>">
                    </div>
                </div>

                <div class="form-grid-2">
                    <!-- Category -->
                    <div class="form-group">
                        <label>Category *</label>
                        <select name="categoryId" required>
                            <option value="">-- Select category --</option>
                            <% if (cats != null) { for (Category cat : cats) { %>
                            <option value="<%= cat.getId() %>"
                                <%= (isEdit && editExpense.getCategoryId() == cat.getId()) ? "selected" : "" %>>
                                <%= cat.getIcon() %> <%= cat.getName() %>
                            </option>
                            <% } } %>
                        </select>
                    </div>

                    <!-- Payment Method -->
                    <div class="form-group">
                        <label>Payment Method</label>
                        <select name="paymentMethod">
                            <% String[] methods = {"cash","card","upi","netbanking","other"};
                               String[] labels  = {"💵 Cash","💳 Card","📱 UPI","🏦 Net Banking","📦 Other"};
                               String selPm = isEdit ? editExpense.getPaymentMethod() : "cash";
                               for (int i = 0; i < methods.length; i++) { %>
                            <option value="<%= methods[i] %>" <%= methods[i].equals(selPm) ? "selected" : "" %>><%= labels[i] %></option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <!-- Notes -->
                <div class="form-group">
                    <label>Notes (optional)</label>
                    <textarea name="notes" rows="3" placeholder="Any extra details..."
                              style="resize:vertical;"><%= isEdit && editExpense.getNotes() != null ? editExpense.getNotes() : "" %></textarea>
                </div>

                <div class="form-actions">
                    <a href="<%= request.getContextPath() %>/expenses" class="btn btn-ghost">Cancel</a>
                    <button type="submit" class="btn btn-primary">
                        <%= isEdit ? "💾 Save Changes" : "➕ Add Expense" %>
                    </button>
                </div>
            </form>
        </div>

        <!-- Quick tips -->
        <div style="margin-top:1.5rem;padding:1rem 1.2rem;background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);font-size:0.82rem;color:var(--text-3);">
            <strong style="color:var(--text-2);">💡 Tips</strong><br>
            Use specific titles like "Dinner at Barbeque Nation" instead of just "Dinner" for better tracking.
            Add notes for receipts or order IDs.
        </div>
    </main>
</div>
</body>
</html>
