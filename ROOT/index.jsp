<%@ page import="java.io.*" %>
<%
String logPath = application.getRealPath("/") + "../../logs/testcve-app.log";
FileWriter fw = new FileWriter(logPath, true);
fw.write(new java.util.Date() + " - User accessed dashboard\n");
fw.close();
%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.io.File" %>
<%
File uploadDir = new File(application.getRealPath("/"), "uploads");
if (!uploadDir.exists()) uploadDir.mkdirs();
File[] uploaded = uploadDir.listFiles();
int fileCount = uploaded == null ? 0 : uploaded.length;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>SecureDocs Portal</title>
<link rel="stylesheet" href="assets/style.css">
</head>
<body>
<div class="layout">
<aside class="sidebar">
<div class="brand"><div class="logo">SD</div><div><h2>SecureDocs</h2><p>Internal Document Portal</p></div></div>
<nav>
<a class="active" href="index.jsp">Dashboard</a>
<a href="upload.jsp">Upload Document</a>
<a href="files.jsp">Document Library</a>
<a href="status.jsp">Server Status</a>
</nav>
<div class="lab-badge">LAB ENVIRONMENT</div>
</aside>
<main class="main">
<header class="topbar"><div><h1>Document Management Dashboard</h1><p>Apache Tomcat controlled lab web application</p></div><a class="btn primary" href="upload.jsp">Upload File</a></header>
<section class="cards">
<div class="card"><span class="label">Uploaded files</span><strong><%= fileCount %></strong><p>Documents stored in /uploads</p></div>
<div class="card"><span class="label">Application</span><strong>testcve</strong><p>Internal upload portal simulation</p></div>
<div class="card"><span class="label">Runtime</span><strong>Tomcat</strong><p>JSP-based lab application</p></div>
</section>
<section class="panel"><h2>Lab Scenario</h2><p>This web application simulates a small internal company document portal. Users can upload business documents, browse uploaded files, and verify server baseline behavior for a controlled Tomcat security lab.</p><div class="notice"><strong>Safety note:</strong> Use only inside your isolated lab VM. Do not expose this webapp to the public Internet.</div></section>
</main>
</div>
</body>
</html>
