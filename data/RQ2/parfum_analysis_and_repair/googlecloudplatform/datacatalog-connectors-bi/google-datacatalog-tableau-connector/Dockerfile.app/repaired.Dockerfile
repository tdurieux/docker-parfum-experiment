# docker build -t tableau2datacatalog .
FROM python:3.7

# Copy the local client library dependency and install it (temporary).
WORKDIR /lib

RUN pip install --no-cache-dir google-cloud-logging

# Install production dependencies.
RUN pip install --no-cache-dir Flask gunicorn

WORKDIR /app

# Copy project files (see .dockerignore).
COPY . .

# Install tableau2datacatalog package from source files.
RUN pip install --no-cache-dir .

CMD exec gunicorn --config gunicorn_config.py app:app
