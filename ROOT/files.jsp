<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.io.File" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
File uploadDir = new File(application.getRealPath("/"), "uploads");
if (!uploadDir.exists()) uploadDir.mkdirs();
File[] files = uploadDir.listFiles();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Document Library - SecureDocs</title>
<link rel="stylesheet" href="assets/style.css">
</head>
<body>
<div class="layout">
<aside class="sidebar">
<div class="brand"><div class="logo">SD</div><div><h2>SecureDocs</h2><p>Internal Document Portal</p></div></div>
<nav><a href="index.jsp">Dashboard</a><a href="upload.jsp">Upload Document</a><a class="active" href="files.jsp">Document Library</a><a href="status.jsp">Server Status</a></nav>
<div class="lab-badge">LAB ENVIRONMENT</div>
</aside>
<main class="main">
<header class="topbar"><div><h1>Document Library</h1><p>Uploaded files stored in the lab portal</p></div>
<div class="topbar-actions">
<form action="delete-file.jsp" method="post" onsubmit="return confirm('Delete ALL uploaded files?');">
<input type="hidden" name="action" value="delete-all">
<button class="btn danger" type="submit">Delete All Files</button>
</form>
<a class="btn primary" href="upload.jsp">Upload File</a>
</div>
</header>
<section class="panel">
<table>
<thead><tr><th>File name</th><th>Size</th><th>Last modified</th><th>Open</th><th>Delete</th></tr></thead>
<tbody>
<%
boolean hasVisibleFiles = false;
if (files != null) {
    for (File checkFile : files) {
        if (checkFile.isFile() && !".keep".equals(checkFile.getName())) {
            hasVisibleFiles = true;
            break;
        }
    }
}
%>
<% if (!hasVisibleFiles) { %>
<tr><td colspan="5" class="empty">No uploaded files yet.</td></tr>
<% } else { for (File f : files) { if (!f.isFile() || ".keep".equals(f.getName())) continue; String name = f.getName(); %>
<tr>
<td><%= name %></td>
<td><%= f.length() %> bytes</td>
<td><%= sdf.format(f.lastModified()) %></td>
<td><a href="uploads/<%= java.net.URLEncoder.encode(name, "UTF-8") %>" target="_blank">Open</a></td>
<td>
<form action="delete-file.jsp" method="post" onsubmit="return confirm('Delete <%= name %>?');">
<input type="hidden" name="file" value="<%= name %>">
<button class="btn danger" type="submit">Delete</button>
</form>
</td>
</tr>
<% }} %>
</tbody>
</table>
</section>
</main>
</div>
</body>
</html>
