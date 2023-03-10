# BUILDER
FROM python:3 as builder

WORKDIR /usr/src/app

# Activate virtualenv
RUN python -m venv /opt/venv

# Make sure we use the virtualenv
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements and build with pip
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt



# RUNTIME
FROM python:3-slim as runtime

WORKDIR /usr/src/app

# Copy compiled venv from builder
COPY --from=builder /opt/venv /opt/venv

# Make sure we use the virtualenv
ENV PATH="/opt/venv/bin:$PATH"

# Copy script over and run
COPY gps_verify.py .
CMD [ "python3", "./gps_verify.py" ]
