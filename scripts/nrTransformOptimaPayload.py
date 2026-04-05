#!/usr/bin/env python3
import json
import sys

def main():
    print("Script Payload:")

    payload = json.loads(sys.argv[1])
    print(json.dumps(payload, indent=4))

if __name__ == "__main__":
    main()