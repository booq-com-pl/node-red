#!/usr/bin/env python3
import json
import sys

def main():
    if len(sys.argv) < 2:
        print(json.dumps({"error": "No input data in sys.argv[1]"}))
        sys.exit(1)

    raw = sys.argv[1].strip()

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