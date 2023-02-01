FROM python:3.10-slim

# Install dependencies required for Containernet.
RUN apt-get update && apt-get install --no-install-recommends -y \
    net-tools \
    iputils-ping \
    iproute2 \
    build-essential \
    htop && rm -rf /var/lib/apt/lists/*;

# Use a virtual environment to avoid running pip as root
ENV VIRTUAL_ENV=/opt/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir Flask redis uwsgi

WORKDIR /app
COPY server.py /app
COPY uwsgi.ini /app

