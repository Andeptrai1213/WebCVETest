<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tomcat CVE-2024-50379 Lab</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 760px; margin: 40px auto; padding: 0 18px; line-height: 1.5; }
        code { background: #f3f3f3; padding: 2px 5px; border-radius: 4px; }
        form { border: 1px solid #ddd; padding: 18px; border-radius: 8px; }
        button { padding: 8px 14px; }
    </style>
</head>
<body>
<h1>Tomcat CVE-2024-50379 Lab</h1>
<p>This local-only lab runs on Tomcat 9 and writes uploaded files under <code>/uploads</code>.</p>
<p>Use it only in an isolated test Tomcat instance. Do not expose this app to an untrusted network.</p>

<form action="upload" method="post" enctype="multipart/form-data">
    <p><label>Upload a test file: <input type="file" name="file" required></label></p>
    <button type="submit">Upload</button>
</form>

<p><a href="health">Health check</a></p>
</body>
</html>
