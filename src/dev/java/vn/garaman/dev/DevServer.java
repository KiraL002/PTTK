package vn.garaman.dev;

import java.io.File;
import java.util.Collections;
import java.util.concurrent.atomic.AtomicBoolean;
import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;
import org.apache.catalina.Context;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

/** Local-only JSP/Servlet development server, excluded from the normal WAR build. */
public class DevServer {
    public static void main(String[] args) throws Exception {
        File root = new File(System.getProperty("user.dir"));
        int port = Integer.parseInt(System.getProperty("garaman.port", "8081"));
        Tomcat tomcat = new Tomcat();
        tomcat.setBaseDir(new File(root, "target/tomcat").getAbsolutePath());
        tomcat.setPort(port);
        tomcat.getConnector().setProperty("address", "127.0.0.1");
        tomcat.getConnector().setURIEncoding("UTF-8");
        Context context = tomcat.addWebapp("", new File(root, "src/main/webapp").getAbsolutePath());
        context.setParentClassLoader(DevServer.class.getClassLoader());
        Throwable[] startupFailure = new Throwable[1];
        context.addServletContainerInitializer(
                (classes, servletContext) ->
                        servletContext.setAttribute("vn.garaman.startupFailure", startupFailure),
                Collections.emptySet());
        StandardRoot resources = new StandardRoot(context);
        resources.addPreResources(
                new DirResourceSet(
                        resources,
                        "/WEB-INF/classes",
                        new File(root, "target/classes").getAbsolutePath(),
                        "/"));
        context.setResources(resources);
        AtomicBoolean stopped = new AtomicBoolean();
        Runnable stop =
                () -> {
                    if (!stopped.compareAndSet(false, true))
                        return;
                    try {
                        tomcat.stop();
                    } catch (Exception ignored) {
                    } finally {
                        try {
                            tomcat.destroy();
                        } catch (Exception ignored) {
                        }
                        // This launcher owns the entire embedded server and its JDBC driver.
                        AbandonedConnectionCleanupThread.uncheckedShutdown();
                    }
                };
        Runtime.getRuntime().addShutdownHook(new Thread(stop));
        try {
            tomcat.start();
            if (!context.getState().isAvailable()
                    || !tomcat.getConnector().getState().isAvailable()) {
                Throwable cause = startupFailure[0];
                Throwable rootCause = cause;
                while (rootCause != null
                        && rootCause.getCause() != null
                        && rootCause.getCause() != rootCause)
                    rootCause = rootCause.getCause();
                String reason =
                        rootCause == null
                                ? "Tomcat khong the khoi dong. Kiem tra cong " + port
                                : rootCause.getClass().getSimpleName()
                                        + ": "
                                        + rootCause.getMessage();
                throw new IllegalStateException("GaraMan khoi dong that bai - " + reason, cause);
            }
            System.out.println("GaraMan: http://localhost:" + port + "/home");
            tomcat.getServer().await();
        } finally {
            stop.run();
        }
    }
}
