#!/usr/bin/env python3
import json
import sys

def main():
    if len(sys.argv) < 2:
        print("Usage: nrTransformOptimaPayload.py <input_file>")
        sys.exit(1)

    input_file = sys.argv[1]

    with open(input_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    nip_index = {}
    for record in data:
        nip = record.get("Baz_Nip")
        if nip is not None:
            nip_index[nip] = record["Baz_NazwaBazy"]

    print(json.dumps(nip_index, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()