package vn.garaman.controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import vn.garaman.config.Database;
import vn.garaman.dao.*;
import vn.garaman.model.*;
import vn.garaman.util.SearchText;

public class SearchServlet3 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = SearchText.clean(request.getParameter("keyword"));
        request.setAttribute("keyword", keyword);
        try (Connection con = Database.open()) {
            switch (request.getServletPath()) {
                case "/service-detail":
                    showServiceDetail(request, response, con);
                    break;
                case "/part-detail":
                    showPartDetail(request, response, con);
                    break;
                default:
                    search(request, response, con, keyword);
            }
        } catch (IllegalArgumentException ex) {
            response.setStatus(400);
            request.setAttribute("message", ex.getMessage());
            Web.view(request, response, "search", "Tìm kiếm dịch vụ / phụ tùng");
        } catch (SQLException ex) {
            Web.databaseError(this, request, response, ex);
        }
    }

    private void search(
            HttpServletRequest request,
            HttpServletResponse response,
            Connection con,
            String keyword)
            throws SQLException, ServletException, IOException {
        if (request.getParameter("keyword") != null) {
            String error = SearchText.validate(keyword);
            if (error != null) {
                response.setStatus(400);
                request.setAttribute("message", error);
            } else {
                Service3[] services = new ServiceDAO3(con).searchService(keyword);
                SparePart3[] parts = new SparePartDAO3(con).searchPart(keyword);
                request.setAttribute("services", services);
                request.setAttribute("spareParts", parts);
                request.setAttribute("searched", true);
                request.setAttribute("serviceCount", services.length);
                request.setAttribute("partCount", parts.length);
                if (services.length == 0 && parts.length == 0)
                    request.setAttribute(
                            "message",
                            "Không tìm thấy dịch vụ hoặc phụ tùng phù hợp. Hãy thử từ khóa khác.");
            }
        }
        Web.view(request, response, "search", "Tìm kiếm dịch vụ / phụ tùng");
    }

    private void showServiceDetail(
            HttpServletRequest request, HttpServletResponse response, Connection con)
            throws SQLException, ServletException, IOException {
        Service3 service = new ServiceDAO3(con).getServiceDetail(Web.id(request, "serviceId"));
        if (service == null) {
            response.setStatus(404);
            request.setAttribute("message", "Dịch vụ không tồn tại hoặc đã ngừng cung cấp.");
        }
        request.setAttribute("service", service);
        Web.view(request, response, "service-detail", "Chi tiết dịch vụ");
    }

    private void showPartDetail(
            HttpServletRequest request, HttpServletResponse response, Connection con)
            throws SQLException, ServletException, IOException {
        SparePart3 part = new SparePartDAO3(con).getPartDetail(Web.id(request, "partId"));
        if (part == null) {
            response.setStatus(404);
            request.setAttribute("message", "Phụ tùng không tồn tại hoặc đã ngừng kinh doanh.");
        }
        request.setAttribute("sparePart", part);
        Web.view(request, response, "part-detail", "Chi tiết phụ tùng");
    }
}
