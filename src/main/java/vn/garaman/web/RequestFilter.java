package vn.garaman.web;
import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;
import javax.servlet.*;
import javax.servlet.http.*;
import vn.garaman.config.Database;

public class RequestFilter implements Filter {
    @Override public void doFilter(ServletRequest request,ServletResponse response,FilterChain chain) throws IOException,ServletException {
        HttpServletRequest q=(HttpServletRequest)request;HttpServletResponse r=(HttpServletResponse)response;
        q.setCharacterEncoding("UTF-8");r.setCharacterEncoding("UTF-8");
        r.setHeader("X-GaraMan-Database",Database.getBackend());
        r.setHeader("X-Content-Type-Options","nosniff");r.setHeader("Referrer-Policy","same-origin");
        r.setHeader("Content-Security-Policy","default-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'; base-uri 'self'; form-action 'self'; frame-ancestors 'none'");
        if(!q.getServletPath().startsWith("/assets/")) {
            r.setHeader("Cache-Control","no-store");HttpSession session=q.getSession();
            if(session.getAttribute("csrf")==null) {byte[] bytes=new byte[32];new SecureRandom().nextBytes(bytes);session.setAttribute("csrf",Base64.getUrlEncoder().withoutPadding().encodeToString(bytes));}
        }
        chain.doFilter(q,r);
    }
    public static boolean csrf(HttpServletRequest q) {
        HttpSession session=q.getSession(false);String supplied=q.getParameter("csrf");
        return session!=null&&supplied!=null&&supplied.equals(session.getAttribute("csrf"));
    }
}
