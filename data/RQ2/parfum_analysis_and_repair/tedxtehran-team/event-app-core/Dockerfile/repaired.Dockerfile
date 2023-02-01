FROM python:3.9-slim AS builder

WORKDIR /

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/apt/cache apt-get update && apt-get install --no-install-recommends -y \
  gcc \
  git \
  libpq-dev && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip pip install --no-cache-dir -r requirements.txt

# --- Final image
FROM python:3.9-slim

WORKDIR /opt/app

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

RUN --mount=type=cache,target=/root/.cache/pip pip install --no-cache-dir gunicorn

RUN --mount=type=cache,target=/var/apt/cache apt-get update && apt-get install --no-install-recommends -y \
  libpq-dev && rm -rf /var/lib/apt/lists/*;

# Copy pip installed packages
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# Copy project files
COPY . .

ARG SECRET_KEY=dummy

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN python manage.py collectstatic --noinput --clear --link

EXPOSE 8000
