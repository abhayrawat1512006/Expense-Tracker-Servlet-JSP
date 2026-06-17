<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.expense.dao.ExpenseDAO, com.expense.model.User" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    // This page handles GET /expenses?action=add
    // Load categories and forward to form
    User u = (User) session.getAttribute("user");
    try {
        com.expense.dao.ExpenseDAO dao = new com.expense.dao.ExpenseDAO();
        request.setAttribute("categories", dao.getCategories(u.getId()));
    } catch (Exception e) {
        throw new jakarta.servlet.ServletException(e);
    }
    request.getRequestDispatcher("/WEB-INF/expense-form.jsp").forward(request, response);
%>
