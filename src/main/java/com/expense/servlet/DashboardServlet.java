package com.expense.servlet;

import com.expense.dao.ExpenseDAO;
import com.expense.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final ExpenseDAO expenseDAO = new ExpenseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        LocalDate now = LocalDate.now();
        int month = now.getMonthValue();
        int year  = now.getYear();

        try {
            BigDecimal monthTotal = expenseDAO.getTotalByMonth(userId, month, year);
            BigDecimal lastMonthTotal = expenseDAO.getTotalByMonth(userId,
                    month == 1 ? 12 : month - 1,
                    month == 1 ? year - 1 : year);

            List<Object[]> categoryBreakdown = expenseDAO.getCategoryBreakdown(userId, month, year);
            List<Object[]> trend             = expenseDAO.getLast6MonthsTrend(userId);
            List<?> recentExpenses           = expenseDAO.getRecentExpenses(userId, 8);

            req.setAttribute("monthTotal",         monthTotal);
            req.setAttribute("lastMonthTotal",      lastMonthTotal);
            req.setAttribute("categoryBreakdown",   categoryBreakdown);
            req.setAttribute("trend",               trend);
            req.setAttribute("recentExpenses",      recentExpenses);
            req.setAttribute("currentMonth",        month);
            req.setAttribute("currentYear",         year);

            req.getRequestDispatcher("/WEB-INF/dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
