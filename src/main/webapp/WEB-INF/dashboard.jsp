<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,java.math.BigDecimal,com.expense.model.*,java.text.NumberFormat,java.util.Locale" %>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    User dashUser = (User) session.getAttribute("user");
    BigDecimal monthTotal = (BigDecimal) request.getAttribute("monthTotal");
    BigDecimal lastMonthTotal = (BigDecimal) request.getAttribute("lastMonthTotal");
    List<Object[]> breakdown = (List<Object[]>) request.getAttribute("categoryBreakdown");
    List<Object[]> trend = (List<Object[]>) request.getAttribute("trend");
    List<com.expense.model.Expense> recent = (List<com.expense.model.Expense>) request.getAttribute("recentExpenses");

    NumberFormat nf = NumberFormat.getInstance(new Locale("en","IN"));
    nf.setMaximumFractionDigits(0);

    BigDecimal change = monthTotal.subtract(lastMonthTotal);
    boolean isUp = change.compareTo(BigDecimal.ZERO) > 0;

    String[] months = {"","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — SpendWise</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>
<div class="app-shell">
    <%@ include file="sidebar.jsp" %>

    <main class="main-content">
        <div class="page-header">
            <div>
                <p class="breadcrumb">OVERVIEW</p>
                <h1>Dashboard 👋</h1>
                <p style="color:var(--text-3);font-size:0.85rem;margin-top:0.25rem;">
                    Good <%= new java.util.Date().getHours() < 12 ? "morning" : new java.util.Date().getHours() < 17 ? "afternoon" : "evening" %>, <%= dashUser.getFullName().split(" ")[0] %>
                </p>
            </div>
            <a href="<%= request.getContextPath() %>/expenses?action=add" class="btn btn-primary">
                + Add Expense
            </a>
        </div>

        <!-- Stats -->
        <div class="stats-grid">
            <div class="stat-card purple">
                <div class="stat-icon">💰</div>
                <div class="stat-value">₹<%= nf.format(monthTotal) %></div>
                <div class="stat-label">This Month</div>
                <div class="stat-change <%= isUp ? "up" : "down" %>">
                    <%= isUp ? "↑" : "↓" %> ₹<%= nf.format(change.abs()) %> vs last month
                </div>
            </div>
            <div class="stat-card teal">
                <div class="stat-icon">📅</div>
                <div class="stat-value">₹<%= nf.format(lastMonthTotal) %></div>
                <div class="stat-label">Last Month</div>
            </div>
            <div class="stat-card gold">
                <div class="stat-icon">🗂</div>
                <div class="stat-value"><%= breakdown != null ? breakdown.size() : 0 %></div>
                <div class="stat-label">Active Categories</div>
            </div>
        </div>

        <!-- Charts Row -->
        <div class="charts-grid">
            <!-- Trend -->
            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="card-title">Spending Trend</div>
                        <div class="card-subtitle">LAST 6 MONTHS</div>
                    </div>
                </div>
                <canvas id="trendChart" height="180"></canvas>
            </div>

            <!-- Category Breakdown -->
            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="card-title">Category Breakdown</div>
                        <div class="card-subtitle">THIS MONTH</div>
                    </div>
                </div>
                <% if (breakdown != null && !breakdown.isEmpty()) { %>
                <div style="display:flex;gap:1.5rem;align-items:center;">
                    <canvas id="categoryChart" width="130" height="130" style="flex-shrink:0;"></canvas>
                    <div style="flex:1;min-width:0;">
                        <% BigDecimal bTotal = breakdown.stream().map(r -> (BigDecimal) r[3])
                               .reduce(BigDecimal.ZERO, BigDecimal::add); %>
                        <% for (Object[] cat : breakdown) { %>
                        <div class="cat-item">
                            <div class="cat-dot" style="background:<%= cat[2] %>;"></div>
                            <div style="flex:1;min-width:0;">
                                <div style="display:flex;justify-content:space-between;">
                                    <span class="cat-name"><%= cat[1] %> <%= cat[0] %></span>
                                    <span class="cat-amount">₹<%= nf.format(cat[3]) %></span>
                                </div>
                                <div class="progress-bar">
                                    <div class="progress-fill"
                                         style="width:<%= bTotal.compareTo(BigDecimal.ZERO) > 0
                                             ? ((BigDecimal)cat[3]).multiply(BigDecimal.valueOf(100)).divide(bTotal, 1, java.math.RoundingMode.HALF_UP)
                                             : 0 %>%;background:<%= cat[2] %>;"></div>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } else { %>
                <div class="empty-state" style="padding:2rem;">
                    <div class="empty-icon">📊</div>
                    <p>No expenses this month</p>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Recent Expenses -->
        <div class="card">
            <div class="card-header">
                <div>
                    <div class="card-title">Recent Expenses</div>
                    <div class="card-subtitle">LATEST TRANSACTIONS</div>
                </div>
                <a href="<%= request.getContextPath() %>/expenses" class="btn btn-ghost btn-sm">View All</a>
            </div>

            <% if (recent != null && !recent.isEmpty()) { %>
            <table class="expense-table">
                <thead>
                    <tr>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Date</th>
                        <th>Method</th>
                        <th style="text-align:right;">Amount</th>
                    </tr>
                </thead>
                <tbody>
                <% for (com.expense.model.Expense exp : recent) { %>
                <tr class="expense-row">
                    <td style="font-weight:500;"><%= exp.getTitle() %></td>
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
                    <td style="text-align:right;" class="amount-cell">₹<%= nf.format(exp.getAmount()) %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="empty-state">
                <div class="empty-icon">💳</div>
                <h3>No expenses yet</h3>
                <p>Start adding your daily expenses to see them here.</p>
            </div>
            <% } %>
        </div>
    </main>
</div>

<script>
// ─── Build trend data ────────────────────────────────────────────────
const trendData = [
    <% if (trend != null) { for (Object[] t : trend) { %>
    { year: <%= t[0] %>, month: <%= t[1] %>, total: <%= t[2] %> },
    <% } } %>
];

const monthNames = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];

const trendCtx = document.getElementById('trendChart');
if (trendCtx) {
    new Chart(trendCtx, {
        type: 'line',
        data: {
            labels: trendData.map(d => monthNames[d.month - 1]),
            datasets: [{
                label: 'Spending',
                data: trendData.map(d => d.total),
                borderColor: '#7c6af5',
                backgroundColor: 'rgba(124,106,245,0.1)',
                borderWidth: 2.5,
                pointBackgroundColor: '#7c6af5',
                pointRadius: 4,
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { color: 'rgba(255,255,255,0.05)' }, ticks: { color: '#a0a0c0', font: { family: 'DM Mono' } } },
                y: { grid: { color: 'rgba(255,255,255,0.05)' }, ticks: { color: '#a0a0c0', font: { family: 'DM Mono' }, callback: v => '₹' + v.toLocaleString('en-IN') } }
            }
        }
    });
}

// ─── Donut chart ─────────────────────────────────────────────────────
const catCtx = document.getElementById('categoryChart');
if (catCtx) {
    const catData = [
        <% if (breakdown != null) { for (Object[] cat : breakdown) { %>
        { name: '<%= ((String)cat[0]).replace("'","") %>', color: '<%= cat[2] %>', total: <%= cat[3] %> },
        <% } } %>
    ];
    if (catData.length > 0) {
        new Chart(catCtx, {
            type: 'doughnut',
            data: {
                labels: catData.map(d => d.name),
                datasets: [{
                    data: catData.map(d => d.total),
                    backgroundColor: catData.map(d => d.color),
                    borderColor: '#070810',
                    borderWidth: 3,
                    hoverOffset: 6
                }]
            },
            options: {
                cutout: '72%',
                plugins: { legend: { display: false }, tooltip: {
                    callbacks: { label: ctx => ' ₹' + Number(ctx.raw).toLocaleString('en-IN') }
                }}
            }
        });
    }
}
</script>
</body>
</html>
