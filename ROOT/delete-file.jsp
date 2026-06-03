<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%
request.setCharacterEncoding("UTF-8");

String action = request.getParameter("action");
String fileName = request.getParameter("file");
String cleanName = "";
String message = "Delete failed";

File uploadDir = new File(application.getRealPath("/"), "uploads");
if (!uploadDir.exists()) {
    uploadDir.mkdirs();
}

if ("delete-all".equals(action)) {
    int deletedCount = 0;
    int failedCount = 0;
    File[] uploadedFiles = uploadDir.listFiles();

    if (uploadedFiles != null) {
        String uploadPath = uploadDir.getCanonicalPath();

        for (File target : uploadedFiles) {
            if (!target.isFile() || ".keep".equals(target.getName())) {
                continue;
            }

            String targetPath = target.getCanonicalPath();
            if (targetPath.startsWith(uploadPath + File.separator)) {
                if (target.delete()) {
                    deletedCount++;
                } else {
                    failedCount++;
                }
            } else {
                failedCount++;
            }
        }
    }

    cleanName = "All uploaded files";

    if (failedCount == 0) {
        message = "Delete all successful: " + deletedCount + " file(s) deleted";
    } else {
        message = "Delete all finished: " + deletedCount + " deleted, " + failedCount + " failed";
    }
} else if (fileName != null && fileName.length() > 0) {
    cleanName = fileName.replace("\\", "/");
    cleanName = cleanName.substring(cleanName.lastIndexOf("/") + 1);
    cleanName = cleanName.replaceAll("[^a-zA-Z0-9._-]", "_");

    File target = new File(uploadDir, cleanName);
    String uploadPath = uploadDir.getCanonicalPath();
    String targetPath = target.getCanonicalPath();

    if (targetPath.startsWith(uploadPath + File.separator) && target.exists() && target.isFile()) {
        if (target.delete()) {
            message = "Delete successful";
        } else {
            message = "Delete failed: cannot delete file";
        }
    } else {
        message = "Delete failed: file not found or blocked";
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Delete Result - SecureDocs</title>
<link rel="stylesheet" href="assets/style.css">
</head>
<body>
<div class="center-page">
    <div class="result-card">
        <div class="result-icon">×</div>
        <h1><%= message %></h1>
        <% if (cleanName.length() > 0) { %>
            <p>Target:</p>
            <code><%= cleanName %></code>
        <% } %>
        <div class="actions">
            <a class="btn primary" href="files.jsp">Back to Documents</a>
            <a class="btn" href="upload.jsp">Upload Another</a>
        </div>
    </div>
</div>
</body>
</html>
