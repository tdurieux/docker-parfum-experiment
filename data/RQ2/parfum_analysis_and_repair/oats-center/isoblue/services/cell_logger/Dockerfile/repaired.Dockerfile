# BUILDER
FROM python:3 as builder

WORKDIR /usr/src/app

# Download latest listing of available packages
RUN apt-get -y update

# Needed for building dbus-python
RUN apt-get install -y --no-install-recommends python3-pip pkg-config libdbus-1-dev libglib2.0-dev libdbus-glib-1-dev python3-dbus && rm -rf /var/lib/apt/lists/*;

# Activate virtualenv
RUN python -m venv /opt/venv

# Make sure we use the virtualenv
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements and build with pip
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt



# RUNTIME
FROM python:3 as runtime

WORKDIR /usr/src/app

# Install runtime deps
RUN apt-get -y update && apt-get install -y --no-install-recommends python3-dbus && rm -rf /var/lib/apt/lists/*;

# Copy compiled venv from builder
COPY --from=builder /opt/venv /opt/venv

# Make sure we use the virtualenv
ENV PATH="/opt/venv/bin:$PATH"

# Copy health check script
COPY healthcheck.py .
HEALTHCHECK CMD ["python", "./healthcheck.py"]

# Copy script over and run
COPY cell_logger.py .
CMD [ "./cell_logger.py" ]
