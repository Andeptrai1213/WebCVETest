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

## Local Demo Helper

The `scripts/cve_2024_50379_local_demo.py` helper is for your own isolated homelab only. By default it refuses non-loopback targets.

Install the Python dependency:

```powershell
py -m pip install requests
```

Run against the deployed lab app:

```powershell
py scripts\cve_2024_50379_local_demo.py --url http://localhost:8080/tomcat-lab/ --mode put
```

If your lab uses the upload servlet instead of Tomcat default-servlet `PUT`, use:

```powershell
py scripts\cve_2024_50379_local_demo.py --url http://localhost:8080/tomcat-lab/ --mode multipart
```

A successful demo prints `CVE_2024_50379_LOCAL_DEMO_MARKER` from the JSP response. This helper does not execute OS commands; it only tries to prove that a JSP was written and executed.

If no success is observed, verify all of these lab conditions:

- Tomcat is in an affected version/configuration for your test plan.
- The app is running on a case-insensitive filesystem such as default Windows NTFS behavior.
- The target path is writable by the web tier.
- JSP compilation/execution is enabled for uploaded or `PUT`-written files.
- The base URL includes the deployed context path, for example `/tomcat-lab/`.
