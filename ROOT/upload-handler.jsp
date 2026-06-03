<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%
String message = "Upload failed";
String uploadedFileName = "";
String contentType = request.getContentType();

if (contentType != null && contentType.toLowerCase().startsWith("multipart/")) {
    String boundary = "--" + contentType.substring(contentType.indexOf("boundary=") + 9);
    ServletInputStream input = request.getInputStream();
    ByteArrayOutputStream buffer = new ByteArrayOutputStream();
    byte[] temp = new byte[8192];
    int read;

    while ((read = input.read(temp)) != -1) {
        buffer.write(temp, 0, read);
    }

    byte[] body = buffer.toByteArray();
    String raw = new String(body, "ISO-8859-1");

    int fileNameIndex = raw.indexOf("filename=\"");
    if (fileNameIndex >= 0) {
        int fileNameStart = fileNameIndex + 10;
        int fileNameEnd = raw.indexOf("\"", fileNameStart);

        uploadedFileName = raw.substring(fileNameStart, fileNameEnd);
        uploadedFileName = uploadedFileName.replace("\\", "/");
        uploadedFileName = uploadedFileName.substring(uploadedFileName.lastIndexOf("/") + 1);
        uploadedFileName = uploadedFileName.replaceAll("[^a-zA-Z0-9._-]", "_");

        if (uploadedFileName.length() == 0) {
            uploadedFileName = "uploaded-file.bin";
        }

        int headerEnd = raw.indexOf("\r\n\r\n", fileNameEnd);
        int fileStart = headerEnd + 4;
        byte[] boundaryBytes = ("\r\n" + boundary).getBytes("ISO-8859-1");
        int fileEnd = -1;

        outer: for (int i = fileStart; i <= body.length - boundaryBytes.length; i++) {
            for (int j = 0; j < boundaryBytes.length; j++) {
                if (body[i + j] != boundaryBytes[j]) {
                    continue outer;
                }
            }
            fileEnd = i;
            break;
        }

        if (fileEnd > fileStart) {
            File uploadDir = new File(application.getRealPath("/"), "uploads");
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            File outputFile = new File(uploadDir, uploadedFileName);
            FileOutputStream fos = new FileOutputStream(outputFile);
            fos.write(body, fileStart, fileEnd - fileStart);
            fos.close();

            message = "Upload successful";
        } else {
            message = "Upload failed: file content not found";
        }
    } else {
        message = "Upload failed: filename not found";
    }
} else {
    message = "Upload failed: request is not multipart/form-data";
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Upload Result - SecureDocs</title>
<link rel="stylesheet" href="assets/style.css">
</head>
<body>
<div class="center-page">
    <div class="result-card">
        <div class="result-icon">✓</div>
        <h1><%= message %></h1>

        <% if (uploadedFileName != null && uploadedFileName.length() > 0) { %>
            <p>Uploaded file:</p>
            <code><%= uploadedFileName %></code>
        <% } %>

        <div class="actions">
            <% if ("Upload successful".equals(message)) { %>
                <form action="delete-file.jsp" method="post" onsubmit="return confirm('Delete <%= uploadedFileName %>?');">
                    <input type="hidden" name="file" value="<%= uploadedFileName %>">
                    <button class="btn danger" type="submit">Delete Uploaded File</button>
                </form>
            <% } %>
            <a class="btn primary" href="files.jsp">View Documents</a>
            <a class="btn" href="upload.jsp">Upload Another</a>
        </div>
    </div>
</div>
</body>
</html>
