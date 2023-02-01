FROM python:3.8.9-slim-buster

# These two environment variables prevent __pycache__/ files.
# since ipython is already present in required, you might as well use it
ENV PYTHONUNBUFFERED 1 PYTHONDONTWRITEBYTECODE 1 PYTHONBREAKPOINT=ipython

RUN : \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    --no-install-recommends \
    python3-dev \
    build-essential \
  && rm -rf /var/lib/apt/lists/* \
  &&:

# Copy the requirements folder to ensure they are cached
COPY requirements ./requirements

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install the requirements.
RUN pip install --no-cache-dir -r requirements/local.txt

# Copy the rest of the code.
COPY . /app

WORKDIR /app

ENTRYPOINT ["bash", "docker/docker-entrypoint.sh"]
