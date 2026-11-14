package vn.garaman.controller;
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import vn.garaman.config.Database;
import vn.garaman.dao.MemberDAO3;
import vn.garaman.model.Manager3;
import vn.garaman.web.*;

public class LoginServlet extends HttpServlet {
    private String next(HttpServletRequest request) {
        String value=request.getParameter("next");
        if(value==null||value.contains("\\")||value.contains("\r")||value.contains("\n")||value.length()>2000)return "/manager";
        String path=value.split("\\?",2)[0];return ManagerFilter.PATHS.contains(path)?value:"/manager";
    }
    @Override protected void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException {
        if(request.getServletPath().equals("/logout")) {response.sendError(405);return;}
        if(request.getSession().getAttribute("manager")!=null) {response.sendRedirect(request.getContextPath()+next(request));return;}
        request.setAttribute("next",next(request));Web.view(request,response,"login","Đăng nhập quản lí");
    }
    @Override protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException {
        if(!RequestFilter.csrf(request)) {response.sendError(403);return;}
        if(request.getServletPath().equals("/logout")) {request.getSession().invalidate();response.sendRedirect(request.getContextPath()+"/home");return;}
        request.setAttribute("next",next(request));String username=request.getParameter("username"),password=request.getParameter("password");
        request.setAttribute("username",username);
        if(username==null||password==null||username.length()>50||password.length()>256||username.isBlank()||password.isEmpty()) {
            response.setStatus(400);request.setAttribute("message","Vui lòng nhập tên đăng nhập và mật khẩu hợp lệ.");Web.view(request,response,"login","Đăng nhập quản lí");return;
        }
        try(Connection con=Database.open()) {
            Manager3 manager=new MemberDAO3(con).authenticateManager(username.strip(),password);
            if(manager==null) {response.setStatus(401);request.setAttribute("message","Tên đăng nhập hoặc mật khẩu không đúng.");Web.view(request,response,"login","Đăng nhập quản lí");return;}
            request.changeSessionId();request.getSession().setAttribute("manager",manager);response.sendRedirect(request.getContextPath()+next(request));
        } catch(SQLException ex) {Web.databaseError(this,request,response,ex);}
    }
}
