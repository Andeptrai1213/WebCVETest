# Tomcat CVE-2024-50379 Local Lab

Minimal WAR app for a controlled Tomcat 9.0.97/JDK 17 lab on Windows 10.

This app provides:

- `/` upload page
- `/upload` multipart upload endpoint
- `/uploads/<name>` static uploaded files
- `/health` environment check

## Build

```powershell
mvn clean package
```

The WAR will be created at:

```text
target\tomcat-lab.war
```

## Deploy On Windows Tomcat 9.0.97

1. Stop Tomcat.
2. Copy `target\tomcat-lab.war` to `%CATALINA_HOME%\webapps\tomcat-lab.war`.
3. Confirm your lab Tomcat has JSP servlet writable/static behavior configured as required by your CVE test plan.
4. Start Tomcat.
5. Open `http://localhost:8080/tomcat-lab/`.
6. Check `http://localhost:8080/tomcat-lab/health`.

## Safety

Use this only on a lab machine or isolated VM. Do not expose it to the internet or a shared network.

## Notes For CVE-2024-50379 Testing

CVE-2024-50379 is a Tomcat race-condition issue involving case-insensitive file systems and default servlet write behavior. Windows is relevant because its default file system behavior is case-insensitive.

This project intentionally stays small and does not include an automated exploit. Use it as a target app for your authorized local testing.
