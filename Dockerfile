FROM nodered/node-red:4.0.9

USER root

RUN apk add --no-cache python3 py3-pip python3-dev build-base && \
    python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip

COPY requirements.txt /tmp/requirements.txt
RUN /opt/venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt && \
    chown -R node-red:node-red /opt/venv

COPY --chown=node-red:node-red settings.js /data/settings.js

ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV="/opt/venv"

USER node-red
