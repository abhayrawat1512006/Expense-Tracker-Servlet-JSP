package com.expense.servlet;

import com.expense.dao.ExpenseDAO;
import com.expense.model.Expense;
import com.expense.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet("/expenses")
public class ExpenseServlet extends HttpServlet {

    private final ExpenseDAO expenseDAO = new ExpenseDAO();

    private User getAuthUser(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return (s != null) ? (User) s.getAttribute("user") : null;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = getAuthUser(req);
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        String action = req.getParameter("action");

        try {
            if ("add".equals(action)) {
                req.setAttribute("categories", expenseDAO.getCategories(user.getId()));
                req.getRequestDispatcher("/WEB-INF/expense-form.jsp").forward(req, resp);
                return;
            }
            if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Expense expense = expenseDAO.getExpenseById(id, user.getId());
                req.setAttribute("expense", expense);
                req.setAttribute("categories", expenseDAO.getCategories(user.getId()));
                req.getRequestDispatcher("/WEB-INF/expense-form.jsp").forward(req, resp);
                return;
            }
            if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                expenseDAO.deleteExpense(id, user.getId());
                resp.sendRedirect(req.getContextPath() + "/expenses?success=deleted");
                return;
            }

            // List with filters
            String month      = req.getParameter("month");
            String year       = req.getParameter("year");
            String categoryId = req.getParameter("categoryId");
            String search     = req.getParameter("search");

            List<Expense> expenses  = expenseDAO.getExpenses(user.getId(), month, year, categoryId, search);
            req.setAttribute("expenses",   expenses);
            req.setAttribute("categories", expenseDAO.getCategories(user.getId()));
            req.setAttribute("filterMonth",      month);
            req.setAttribute("filterYear",       year);
            req.setAttribute("filterCategoryId", categoryId);
            req.setAttribute("filterSearch",     search);

            req.getRequestDispatcher("/WEB-INF/expenses.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = getAuthUser(req);
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            Expense e = new Expense();
            System.out.println("LOGGED USER ID = " + user.getId());
            System.out.println("LOGGED USERNAME = " + user.getUsername());
            e.setUserId(user.getId());
            e.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
            e.setTitle(req.getParameter("title"));
            e.setAmount(new BigDecimal(req.getParameter("amount")));
            e.setExpenseDate(Date.valueOf(req.getParameter("expenseDate")));
            e.setNotes(req.getParameter("notes"));
            e.setPaymentMethod(req.getParameter("paymentMethod"));

            if ("add".equals(action)) {
                expenseDAO.addExpense(e);
                resp.sendRedirect(req.getContextPath() + "/expenses?success=added");
            } else if ("update".equals(action)) {
                e.setId(Integer.parseInt(req.getParameter("id")));
                expenseDAO.updateExpense(e);
                resp.sendRedirect(req.getContextPath() + "/expenses?success=updated");
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
}
