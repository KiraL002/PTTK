package vn.garaman.controller;

import java.io.IOException;
import java.sql.*;
import java.time.YearMonth;
import java.util.Map;
import javax.servlet.*;
import javax.servlet.http.*;
import vn.garaman.config.Database;
import vn.garaman.dao.InvoiceDAO3;

public class PageController extends HttpServlet {
    private static final Map<String, String> TITLES =
            Map.of(
                    "/home",
                    "Trang chủ",
                    "/manager",
                    "Trang chủ quản lí",
                    "/reports",
                    "Báo cáo",
                    "/customer-statistics",
                    "Thống kê khách hàng",
                    "/statistics-period",
                    "Chọn thời gian thống kê");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if (path.equals("/statistics-period")) {
            try (Connection con = Database.open()) {
                YearMonth month = new InvoiceDAO3(con).getLatestPaidMonth();
                request.setAttribute("startDate", month.atDay(1));
                request.setAttribute("endDate", month.atEndOfMonth());
            } catch (SQLException ex) {
                Web.databaseError(this, request, response, ex);
                return;
            }
        }
        Web.view(request, response, path.substring(1), TITLES.get(path));
    }
}
