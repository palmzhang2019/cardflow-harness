#!/usr/bin/env python3
import os
import sys
import json
import ssl
import urllib.request
import urllib.error

try:
    import certifi
except ImportError:
    certifi = None


def main():
    if len(sys.argv) < 3:
        print("Usage: call-deepseek.py <input_file> <output_file> [model]", file=sys.stderr)
        print("Example: call-deepseek.py input.md output.md deepseek-v4-pro", file=sys.stderr)
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    model = sys.argv[3] if len(sys.argv) >= 4 else "deepseek-v4-pro"

    api_key = os.environ.get("DEEPSEEK_API_KEY")
    if not api_key:
        print("ERROR: DEEPSEEK_API_KEY is not set", file=sys.stderr)
        sys.exit(1)

    with open(input_file, "r", encoding="utf-8") as f:
        prompt = f.read()

    payload = {
        "model": model,
        "messages": [
            {
                "role": "system",
                "content": "You are a strict Requirement Card generation agent. Follow the user's instructions exactly."
            },
            {
                "role": "user",
                "content": prompt
            }
        ],
        "temperature": 0.4,
        "max_tokens": 12000,
        "stream": False
    }

    req = urllib.request.Request(
        "https://api.deepseek.com/chat/completions",
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        },
        method="POST",
    )

    if certifi:
        context = ssl.create_default_context(cafile=certifi.where())
    else:
        context = ssl.create_default_context()

    try:
        with urllib.request.urlopen(req, timeout=300, context=context) as resp:
            body = resp.read().decode("utf-8")
            data = json.loads(body)
    except urllib.error.HTTPError as e:
        err = e.read().decode("utf-8", errors="replace")
        print(f"HTTP ERROR {e.code}: {err}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(1)

    try:
        content = data["choices"][0]["message"]["content"]
    except Exception:
        print("ERROR: unexpected API response:", file=sys.stderr)
        print(json.dumps(data, ensure_ascii=False, indent=2), file=sys.stderr)
        sys.exit(1)

    with open(output_file, "w", encoding="utf-8") as f:
        f.write(content.rstrip() + "\n")

    print(f"OK: generated {output_file}")


if __name__ == "__main__":
    main()
