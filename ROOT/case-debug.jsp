<%@ page import="java.io.*" %>
<pre>
<%
String base = application.getRealPath("/uploads");
File f1 = new File(base, "harmless.Jsp");
File f2 = new File(base, "harmless.jsp");

out.println("Upload dir: " + base);
out.println("harmless.Jsp exists: " + f1.exists());
out.println("harmless.jsp exists: " + f2.exists());
out.println("harmless.Jsp canonical: " + f1.getCanonicalPath());
out.println("harmless.jsp canonical: " + f2.getCanonicalPath());
out.println("Same canonical path: " + f1.getCanonicalPath().equalsIgnoreCase(f2.getCanonicalPath()));
%>
</pre>
