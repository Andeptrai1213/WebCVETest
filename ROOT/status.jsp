<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%
File uploadDir = new File(application.getRealPath("/"), "uploads");
if (!uploadDir.exists()) uploadDir.mkdirs();
String uploadPath = uploadDir.getAbsolutePath();
File probeUpper = new File(uploadDir, "status-case-probe.TXT");
File probeLower = new File(uploadDir, "status-case-probe.txt");
if (!probeUpper.exists() && !probeLower.exists()) {
    try (FileWriter writer = new FileWriter(probeUpper)) {
        writer.write("case probe");
    }
}
boolean caseInsensitive = probeLower.exists();
String canonCaches = System.getProperty("sun.io.useCanonCaches");
%>
<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8"><title>Server Status - SecureDocs</title><link rel="stylesheet" href="assets/style.css"></head>
<body><div class="layout"><aside class="sidebar"><div class="brand"><div class="logo">SD</div><div><h2>SecureDocs</h2><p>Internal Document Portal</p></div></div><nav><a href="index.jsp">Dashboard</a><a href="upload.jsp">Upload Document</a><a href="files.jsp">Document Library</a><a class="active" href="status.jsp">Server Status</a></nav><div class="lab-badge">LAB ENVIRONMENT</div></aside><main class="main"><header class="topbar"><div><h1>Server Status</h1><p>Baseline information for controlled lab documentation</p></div></header><section class="panel"><div class="status-grid"><div><span>Application</span><strong>SecureDocs / testcve</strong></div><div><span>Server software</span><strong><%= application.getServerInfo() %></strong></div><div><span>Java version</span><strong><%= System.getProperty("java.version") %></strong></div><div><span>Java home</span><strong><%= System.getProperty("java.home") %></strong></div><div><span>Canonical cache property</span><strong><%= canonCaches == null ? "not set" : canonCaches %></strong></div><div><span>Operating system</span><strong><%= System.getProperty("os.name") %></strong></div><div><span>Upload directory</span><strong><%= uploadPath %></strong></div><div><span>Writable</span><strong><%= uploadDir.canWrite() %></strong></div><div><span>Case-insensitive uploads</span><strong><%= caseInsensitive %></strong></div></div><div class="notice">For CVE-2024-50379 lab reproduction, the target should be Tomcat 9.0.97, DefaultServlet readonly=false, writable uploads, and a case-insensitive filesystem.</div></section></main></div></body></html>
