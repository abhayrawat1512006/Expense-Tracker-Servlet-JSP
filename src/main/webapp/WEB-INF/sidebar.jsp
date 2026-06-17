<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.expense.model.User" %>
<%
    User sidebarUser = (User) session.getAttribute("user");
    String currentPath = request.getServletPath();
    String initial = sidebarUser != null
            ? String.valueOf(sidebarUser.getFullName().charAt(0)).toUpperCase()
            : "U";
%>

<aside class="sidebar">
    <div class="sidebar-logo">
        <div class="mark">💸</div>
        <span>SpendWise</span>
    </div>

    <p class="nav-section-title">Main</p>

    <a href="<%= request.getContextPath() %>/dashboard"
       class="nav-link <%= currentPath.contains("dashboard") ? "active" : "" %>">
        <span class="nav-icon">📊</span> Dashboard
    </a>

    <a href="<%= request.getContextPath() %>/expenses"
       class="nav-link <%= currentPath.contains("expenses") && request.getQueryString() == null ? "active" : "" %>">
        <span class="nav-icon">📋</span> All Expenses
    </a>

    <a href="<%= request.getContextPath() %>/expenses?action=add"
       class="nav-link">
        <span class="nav-icon">➕</span> Add Expense
    </a>

    <p class="nav-section-title" style="margin-top:auto;">Account</p>

    <a href="<%= request.getContextPath() %>/auth?action=logout"
       class="nav-link">
        <span class="nav-icon">🚪</span> Logout
    </a>

    <div class="sidebar-user" style="margin-top:1rem;">
        <div class="user-avatar"><%= initial %></div>
        <div class="user-info">
            <div class="user-name">
                <%= sidebarUser != null ? sidebarUser.getFullName() : "User" %>
            </div>
            <div class="user-handle">
                @<%= sidebarUser != null ? sidebarUser.getUsername() : "" %>
            </div>
        </div>
    </div>
</aside>