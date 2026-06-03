package local.lab;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class HealthServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/plain; charset=UTF-8");
        resp.getWriter().println("Tomcat CVE-2024-50379 lab is running");
        resp.getWriter().println("Java: " + System.getProperty("java.version"));
        resp.getWriter().println("OS: " + System.getProperty("os.name") + " " + System.getProperty("os.version"));
        resp.getWriter().println("Servlet path: " + req.getServletPath());
    }
}
