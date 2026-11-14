package vn.garaman.web;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Set;
import javax.servlet.*;
import javax.servlet.http.*;
import vn.garaman.model.Manager3;

public class ManagerFilter implements Filter {
    public static final Set<String> PATHS=Set.of("/manager","/reports","/customer-statistics","/statistics-period","/statistics-result","/customer-visits","/invoice-detail");
    @Override public void doFilter(ServletRequest request,ServletResponse response,FilterChain chain) throws IOException,ServletException {
        HttpServletRequest q=(HttpServletRequest)request;HttpServletResponse r=(HttpServletResponse)response;
        if(PATHS.contains(q.getServletPath())) {
            q.setAttribute("managerArea",true);HttpSession session=q.getSession(false);
            if(session==null||!(session.getAttribute("manager") instanceof Manager3)) {
                String next=q.getServletPath()+(q.getQueryString()==null?"":"?"+q.getQueryString());
                r.sendRedirect(q.getContextPath()+"/login?next="+URLEncoder.encode(next,StandardCharsets.UTF_8));return;
            }
        }
        chain.doFilter(q,r);
    }
}
