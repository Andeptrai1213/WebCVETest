<%
application.log("User visited upload page");
%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Upload Document - SecureDocs</title><link rel="stylesheet" href="assets/style.css"></head>
<body>
<div class="layout">
<aside class="sidebar">
<div class="brand"><div class="logo">SD</div><div><h2>SecureDocs</h2><p>Internal Document Portal</p></div></div>
<nav><a href="index.jsp">Dashboard</a><a class="active" href="upload.jsp">Upload Document</a><a href="files.jsp">Document Library</a><a href="status.jsp">Server Status</a></nav>
<div class="lab-badge">LAB ENVIRONMENT</div>
</aside>
<main class="main">
<header class="topbar"><div><h1>Upload Document</h1><p>Upload internal documents to the lab portal</p></div></header>
<section class="panel upload-panel">
<form action="upload-handler.jsp" method="post" enctype="multipart/form-data" class="upload-box">
<div class="upload-icon">↑</div><h2>Select a file to upload</h2><p>Recommended for testing: .txt, .pdf, .docx, .png</p>
<input type="file" name="file" required>
<button class="btn primary" type="submit">Upload Document</button>
</form>
<div class="notice">This feature stores files inside the webapp <code>/uploads</code> directory for lab testing.</div>
</section>
</main>
</div>
</body>
</html>
