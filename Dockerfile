FROM nodered/node-red:latest

USER root

# Instalacja Pythona i narzędzi venv
RUN apk add --no-cache python3 py3-pip python3-dev build-base && \
    python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip

# Kopiowanie i instalacja requirements.txt
COPY requirements.txt /tmp/requirements.txt
RUN /opt/venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt && \
    chown -R node-red:node-red /opt/venv

COPY --chown=node-red:node-red settings.js /data/settings.js

# Dodanie venv do PATH dla wszystkich procesów
ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV="/opt/venv"

USER node-red
