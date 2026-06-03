package local.lab;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

@MultipartConfig
public class UploadServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Part file = req.getPart("file");
        String submittedName = Path.of(file.getSubmittedFileName()).getFileName().toString();
        Path uploadsDir = Path.of(getServletContext().getRealPath("/uploads"));
        Files.createDirectories(uploadsDir);

        Path destination = uploadsDir.resolve(submittedName).normalize();
        if (!destination.startsWith(uploadsDir)) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid file name");
            return;
        }

        try (InputStream input = file.getInputStream()) {
            Files.copy(input, destination, StandardCopyOption.REPLACE_EXISTING);
        }

        resp.setContentType("text/html; charset=UTF-8");
        resp.getWriter().println("<!doctype html><html><body>");
        resp.getWriter().println("<h1>Uploaded</h1>");
        resp.getWriter().println("<p>Saved as: <code>uploads/" + escapeHtml(submittedName) + "</code></p>");
        resp.getWriter().println("<p>Open: <a href=\"uploads/" + escapeAttribute(submittedName) + "\">uploads/" + escapeHtml(submittedName) + "</a></p>");
        resp.getWriter().println("<p><a href=\"./\">Back</a></p>");
        resp.getWriter().println("</body></html>");
    }

    private String escapeHtml(String value) {
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }

    private String escapeAttribute(String value) {
        return escapeHtml(value).replace(" ", "%20");
    }
}
