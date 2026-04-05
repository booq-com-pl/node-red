#!/usr/bin/env python3
import json
import sys

def main():
    raw = sys.stdin.read().strip()
    if not raw:
        print(json.dumps({"error": "No input data on stdin"}))
        sys.exit(1)

    try:
        rows = json.loads(raw)
    except Exception as e:
        print(json.dumps({"error": f"Incorrect JSON: {e}"}))
        sys.exit(1)

    result = {}

    for row in rows:
        nip = row.get("Baz_Nip")
        if not nip:
            continue

        result[nip] = {
            "nazwa": row.get("Baz_Nazwa"),
            "baza": row.get("Baz_NazwaBazy")
        }

    print(json.dumps(result, ensure_ascii=False))

if __name__ == "__main__":
    main()