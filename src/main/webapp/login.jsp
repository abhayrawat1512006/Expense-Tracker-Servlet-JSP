<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — SpendWise</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="auth-wrapper">
    <!-- Left Art Panel -->
    <div class="auth-art">
        <div class="auth-logo">
            <div class="logo-mark">💸</div>
            <h1>SpendWise</h1>
            <p>// your financial co-pilot</p>
        </div>
        <div class="auth-stats">
            <div class="auth-stat">
                <div class="stat-num">10+</div>
                <div class="stat-label">Categories</div>
            </div>
            <div class="auth-stat">
                <div class="stat-num">∞</div>
                <div class="stat-label">Expenses</div>
            </div>
            <div class="auth-stat">
                <div class="stat-num">6mo</div>
                <div class="stat-label">Trends</div>
            </div>
        </div>
    </div>

    <!-- Right Form Panel -->
    <div class="auth-form-side">
        <div class="auth-form-box">
            <p class="breadcrumb" style="font-family:var(--font-mono);font-size:0.75rem;color:var(--text-3);margin-bottom:0.5rem;">WELCOME BACK</p>
            <h2>Sign in to your account</h2>
            <p class="subtitle">Track every rupee, own every decision.</p>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">⚠ <%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">✓ <%= request.getAttribute("success") %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/auth" method="POST">
                <input type="hidden" name="action" value="login">

                <div class="form-group">
                    <label>Username or Email</label>
                    <input type="text" name="username" placeholder="your_username" required autofocus>
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="margin-top:0.5rem;">
                    Sign in →
                </button>
            </form>

            <p style="margin-top:1.5rem;font-size:0.88rem;color:var(--text-3);text-align:center;">
                New here?
                <a href="<%= request.getContextPath() %>/register.jsp"
                   style="color:var(--accent);text-decoration:none;font-weight:600;">Create an account</a>
            </p>
        </div>
    </div>
</div>
</body>
</html>
