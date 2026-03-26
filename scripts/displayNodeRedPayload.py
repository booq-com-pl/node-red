import sys
import json
from tabulate import tabulate

data = json.loads(sys.stdin.readline())

if isinstance(data, list) and data:
    print(tabulate(data, headers="keys", tablefmt="grid"))
    print(f"\nTotal rows: {len(data)}")
elif isinstance(data, dict):
    print(tabulate(data.items(), headers=["Key", "Value"], tablefmt="grid"))
else:
    print(data)
