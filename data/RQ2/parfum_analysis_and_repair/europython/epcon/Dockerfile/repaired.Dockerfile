# Base image
FROM python:3.9

# Update system
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y autoremove

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                    build-essential \
                    sqlite3 && rm -rf /var/lib/apt/lists/*;

# Create main code folder
RUN mkdir /code
WORKDIR /code

# Install dependencies (simulates `make install` in the live dockerfile)
RUN pip install --no-cache-dir -U pip==19.3.1
RUN pip install --no-cache-dir -U pip-tools
COPY ./requirements*.txt /tmp/
RUN pip-sync /tmp/requirements.txt /tmp/requirements-dev.txt

ENTRYPOINT ["/bin/bash", "-c"]
