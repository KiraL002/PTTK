package vn.garaman.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.Map;
import javax.servlet.*;
import javax.servlet.http.*;
import vn.garaman.config.Database;
import vn.garaman.dao.*;
import vn.garaman.model.*;
import vn.garaman.util.Period;

public class CustomerStatisticsServlet3 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection con = Database.open()) {
            Period period = Web.period(request);
            Web.dates(request, period);
            switch (request.getServletPath()) {
                case "/customer-visits":
                    showCustomerVisits(request, response, con, period);
                    break;
                case "/invoice-detail":
                    showInvoiceDetail(request, response, con, period);
                    break;
                default:
                    showStatistics(request, response, con, period);
            }
        } catch (IllegalArgumentException ex) {
            response.setStatus(400);
            request.setAttribute("message", ex.getMessage());
            request.setAttribute("startDate", request.getParameter("startDate"));
            request.setAttribute("endDate", request.getParameter("endDate"));
            Web.view(request, response, "statistics-period", "Chọn thời gian thống kê");
        } catch (SQLException ex) {
            Web.databaseError(this, request, response, ex);
        }
    }

    private void showStatistics(
            HttpServletRequest request, HttpServletResponse response, Connection con, Period period)
            throws SQLException, ServletException, IOException {
        CustomerStatistics3[] statistics =
                new CustomerStatisticsDAO3(con)
                        .getStatistics(period.getStartDate(), period.getEndDate());
        BigDecimal revenue = BigDecimal.ZERO;
        int visits = 0;
        for (CustomerStatistics3 row : statistics) {
            revenue = revenue.add(row.getTotalRevenue());
            visits += row.getVisitCount();
        }
        request.setAttribute("statistics", statistics);
        request.setAttribute("customerCount", statistics.length);
        request.setAttribute("totalVisits", visits);
        request.setAttribute("totalRevenue", revenue);
        Web.view(request, response, "statistics-result", "Thống kê khách hàng theo doanh thu");
    }

    private void showCustomerVisits(
            HttpServletRequest request, HttpServletResponse response, Connection con, Period period)
            throws SQLException, ServletException, IOException {
        int id = Web.id(request, "customerId");
        Customer3 customer = new CustomerDAO3(con).getCustomerById(id);
        if (customer == null) {
            response.setStatus(404);
            request.setAttribute(
                    "message", "Khách hàng không tồn tại. Vui lòng chọn lại từ bảng thống kê.");
            showStatistics(request, response, con, period);
            return;
        }
        InvoiceDAO3 dao = new InvoiceDAO3(con);
        Invoice3[] invoices = dao.getInvoiceList(id, period.getStartDate(), period.getEndDate());
        Map<Integer, Car3> carsByInvoice = dao.getCarsByInvoices(invoices);
        customer.setInvoices(invoices);
        BigDecimal total = BigDecimal.ZERO;
        for (Invoice3 invoice : invoices) {
            invoice.setCustomer(customer);
            invoice.setCar(carsByInvoice.get(invoice.getId()));
            total = total.add(invoice.getTotalAmount());
        }
        request.setAttribute("customer", customer);
        request.setAttribute("invoices", invoices);
        request.setAttribute("visitCount", invoices.length);
        request.setAttribute("totalRevenue", total);
        Web.view(request, response, "customer-visits", "Các lần đến sửa xe");
    }

    private void showInvoiceDetail(
            HttpServletRequest request, HttpServletResponse response, Connection con, Period period)
            throws SQLException, ServletException, IOException {
        int customerId = Web.id(request, "customerId");
        InvoiceDAO3 dao = new InvoiceDAO3(con);
        Invoice3 invoice =
                dao.getInvoiceDetail(
                        Web.id(request, "invoiceId"),
                        customerId,
                        period.getStartDate(),
                        period.getEndDate());
        if (invoice == null) {
            response.setStatus(404);
            request.setAttribute(
                    "message",
                    "Hóa đơn không thuộc khách hàng hoặc khoảng thời gian đang xem, hoặc chưa được thanh toán.");
            showCustomerVisits(request, response, con, period);
            return;
        }
        invoice.setCustomer(new CustomerDAO3(con).getCustomerById(customerId));
        invoice.setSalesStaff(dao.getSalesStaffByInvoice(invoice.getId()));
        invoice.setCar(dao.getCarsByInvoices(new Invoice3[] {invoice}).get(invoice.getId()));
        request.setAttribute("invoice", invoice);
        Web.view(request, response, "invoice-detail", "Chi tiết hóa đơn");
    }
}
