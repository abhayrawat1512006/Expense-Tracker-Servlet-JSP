<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>404 — SpendWise</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body style="display:flex;align-items:center;justify-content:center;min-height:100vh;flex-direction:column;gap:1rem;">
    <div style="font-size:5rem;">😵</div>
    <h1 style="font-size:2rem;">Page Not Found</h1>
    <p style="color:var(--text-3);">The page you're looking for doesn't exist.</p>
    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">Go to Dashboard</a>
</body>
</html>
