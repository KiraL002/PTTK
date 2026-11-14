package vn.garaman.config;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class ApplicationListener implements ServletContextListener {
    @Override public void contextInitialized(ServletContextEvent event) {
        try { Database.start(); event.getServletContext().log("GaraMan JDBC database is ready (" + Database.getBackend() + ")."); }
        catch (Exception ex) {
            // The embedded launcher retains the exception even after Tomcat clears context attributes.
            Object startupFailure = event.getServletContext().getAttribute("vn.garaman.startupFailure");
            if (startupFailure instanceof Throwable[]) ((Throwable[]) startupFailure)[0] = ex;
            Database.stop();
            throw new IllegalStateException("Không thể khởi tạo CSDL GaraMan. Kiểm tra cấu hình và nhật ký máy chủ.", ex);
        }
    }

    @Override public void contextDestroyed(ServletContextEvent event) { Database.stop(); }
}
