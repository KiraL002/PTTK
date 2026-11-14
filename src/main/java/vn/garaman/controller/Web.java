package vn.garaman.controller;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.*;
import javax.servlet.http.*;
import vn.garaman.util.Period;

final class Web {
    private Web() { }
    static void view(HttpServletRequest request, HttpServletResponse response, String page, String title) throws ServletException, IOException {
        String directory;
        switch(page) {
            case "login":
                directory="member/";break;
            case "home":
            case "search":
            case "service-detail":
            case "part-detail":
                directory="customer/";break;
            case "manager":
            case "reports":
            case "customer-statistics":
            case "statistics-period":
            case "statistics-result":
            case "customer-visits":
            case "invoice-detail":
                directory="manager/";break;
            case "error":
                directory="";break;
            default:
                throw new ServletException("Unknown view: "+page);
        }
        request.setAttribute("page",page); request.setAttribute("pageTitle",title);
        request.getRequestDispatcher("/WEB-INF/view/"+directory+page+".jsp").forward(request,response);
    }
    static int id(HttpServletRequest request, String name) {
        String value=request.getParameter(name);
        if(value==null && !name.equals("customerId")) value=request.getParameter("id");
        try { int id=Integer.parseInt(value); if(id>0)return id; } catch(NumberFormatException ignored) { }
        throw new IllegalArgumentException("Mã đối tượng không hợp lệ.");
    }
    static Period period(HttpServletRequest request) {
        String start=request.getParameter("startDate");
        String end=request.getParameter("endDate");
        return Period.parse(start,end);
    }
    static void dates(HttpServletRequest request, Period period) { request.setAttribute("startDate",period.getStartDate()); request.setAttribute("endDate",period.getEndDate()); }
    static void databaseError(HttpServlet servlet,HttpServletRequest request,HttpServletResponse response,SQLException ex) throws ServletException,IOException {
        servlet.getServletContext().log("JDBC request failed: "+request.getServletPath(),ex);
        response.setStatus(503); request.setAttribute("message","Chưa thể truy cập dữ liệu. Vui lòng thử lại sau.");
        view(request,response,"error","Không thể tải dữ liệu");
    }
}
