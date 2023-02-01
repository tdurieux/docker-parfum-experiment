# Build image
FROM python:3.7-slim as builder

# Setup virtualenv
ENV VIRTUAL_ENV=/opt/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install build deps
RUN apt-get update && apt-get install -y --no-install-recommends build-essential pkg-config libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN python -m pip install --upgrade pip
RUN pip install --no-cache-dir wheel

# Install runtime deps
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Install c-lightning specific deps
RUN pip install --no-cache-dir pylightning

# Install LND specific deps
RUN pip install --no-cache-dir lndgrpc

# Production image
FROM python:3.7-slim as lnbits

# Run as non-root
USER 1000:1000

# Copy over virtualenv
ENV VIRTUAL_ENV="/opt/venv"
COPY --from=builder --chown=1000:1000 $VIRTUAL_ENV $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Copy in app source
WORKDIR /app
COPY --chown=1000:1000 lnbits /app/lnbits

ENV LNBITS_PORT="5000"
ENV LNBITS_HOST="0.0.0.0"

EXPOSE 5000

CMD ["sh", "-c", "uvicorn lnbits.__main__:app --port $LNBITS_PORT --host $LNBITS_HOST"]
