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
    <title>Register — SpendWise</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-art">
        <div class="auth-logo">
            <div class="logo-mark">💸</div>
            <h1>SpendWise</h1>
            <p>// start tracking today</p>
        </div>
        <div class="auth-stats">
            <div class="auth-stat"><div class="stat-num">Free</div><div class="stat-label">Forever</div></div>
            <div class="auth-stat"><div class="stat-num">UPI</div><div class="stat-label">Cards</div></div>
            <div class="auth-stat"><div class="stat-num">📊</div><div class="stat-label">Analytics</div></div>
        </div>
    </div>

    <div class="auth-form-side">
        <div class="auth-form-box">
            <p class="breadcrumb" style="font-family:var(--font-mono);font-size:0.75rem;color:var(--text-3);margin-bottom:0.5rem;">GET STARTED</p>
            <h2>Create your account</h2>
            <p class="subtitle">Join and take control of your finances.</p>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">⚠ <%= request.getAttribute("error") %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/auth" method="POST">
                <input type="hidden" name="action" value="register">

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" placeholder="Rahul Sharma" required>
                </div>

                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" placeholder="rahul_sharma" required
                           pattern="[a-zA-Z0-9_]{3,50}">
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" placeholder="rahul@example.com" required>
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="Min. 6 characters"
                           required minlength="6">
                </div>

                <button type="submit" class="btn btn-primary btn-block">
                    Create account →
                </button>
            </form>

            <p style="margin-top:1.5rem;font-size:0.88rem;color:var(--text-3);text-align:center;">
                Already have an account?
                <a href="<%= request.getContextPath() %>/login.jsp"
                   style="color:var(--accent);text-decoration:none;font-weight:600;">Sign in</a>
            </p>
        </div>
    </div>
</div>
</body>
</html>
