Booq
====

### About

Node-RED instance with Python support, packaged as a Docker image and deployed to Kubernetes.

## Python scripts

Python scripts are located in the `scripts/` directory and run inside the container using the venv at `/opt/venv`.

### displayNodeRedPayload.py

Reads `msg.payload` passed from the previous Node-RED node (via `pythonshell in`) and prints it as a formatted table.

**In Node-RED** — set the script path in the `pythonshell in` node to:

```
/data/scripts/displayNodeRedPayload.py
```

**Locally** — pass a JSON payload via stdin:

```bash
echo '[{"NumerFaktury": "FV/1/2025", "DataWystawienia": "2025-01-15"}]' | \
  /opt/venv/bin/python scripts/displayNodeRedPayload.py
```