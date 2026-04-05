Booq — Node-RED
===============

Node-RED instance with Python support, packaged as a Docker image.

## Requirements

- Docker with Compose plugin
- Git

## First-time setup

### 1. Clone the repository

```bash
git clone https://github.com/booq-com-pl/node-red
cd node-red
```

### 2. Create `.env` file

```bash
cp .env.example .env
```

Edit `.env` and fill in the values:

```env
NODE_RED_CREDENTIAL_SECRET=your-secret-key
NODE_RED_ADMIN_USER=admin
NODE_RED_ADMIN_PASSWORD_HASH=your-bcrypt-hash
```

Generate a bcrypt hash for your admin password:

```bash
docker run --rm nodered/node-red node -e \
  "console.log(require('bcryptjs').hashSync('your-password', 8))"
```

### 3. Build and start

```bash
docker-compose up -d --build
```

Node-RED will be available at `http://<host>:1880`.

## Day-to-day commands

```bash
# Start
docker-compose up -d

# Rebuild after Dockerfile or requirements.txt changes
docker-compose up -d --build

# Stop
docker-compose down

# View logs
docker-compose logs -f
```

## Python scripts

Scripts in `scripts/` are copied into the container at `/data/scripts/` and run using the venv at `/opt/venv`.

### displayNodeRedPayload.py

Reads `msg.payload` from the previous Node-RED node (via `pythonshell in`) and prints it as a formatted table.

In the `pythonshell in` node set the script path to:

```
/data/scripts/displayNodeRedPayload.py
```

## Adding Python packages

Add packages to `requirements.txt`, then rebuild:

```bash
docker-compose up -d --build
```
