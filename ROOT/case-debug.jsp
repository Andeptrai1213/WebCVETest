<%@ page import="java.io.*" %>
<pre>
<%
String base = application.getRealPath("/uploads");
String name = request.getParameter("name");
if (name == null || name.length() == 0) name = "harmless";
name = name.replaceAll("[^a-zA-Z0-9._-]", "_");
File f1 = new File(base, name + ".Jsp");
File f2 = new File(base, name + ".jsp");
File probeUpper = new File(base, "case-probe.TXT");
File probeLower = new File(base, "case-probe.txt");

if (!probeUpper.exists() && !probeLower.exists()) {
    try (FileWriter writer = new FileWriter(probeUpper)) {
        writer.write("case probe");
    }
}

out.println("Upload dir: " + base);
out.println("Name: " + name);
out.println(name + ".Jsp exists: " + f1.exists());
out.println(name + ".jsp exists: " + f2.exists());
out.println(name + ".Jsp canonical: " + f1.getCanonicalPath());
out.println(name + ".jsp canonical: " + f2.getCanonicalPath());
out.println("Same canonical path: " + f1.getCanonicalPath().equals(f2.getCanonicalPath()));
out.println("Same canonical path ignoring case: " + f1.getCanonicalPath().equalsIgnoreCase(f2.getCanonicalPath()));
out.println("Filesystem appears case-insensitive: " + probeLower.exists());
%>
</pre>
