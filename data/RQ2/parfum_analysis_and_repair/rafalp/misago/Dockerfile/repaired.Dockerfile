# This dockerfile is only meant for local development of Misago
# If you are looking for a proper docker setup for running Misago in production,
# please use misago-docker instead
FROM python:3.7

ENV PYTHONUNBUFFERED 1
ENV IN_MISAGO_DOCKER 1

# Install dependencies in one single command/layer
RUN apt-get update && apt-get install --no-install-recommends -y \
    vim \
    libffi-dev \
    libssl-dev \
    sqlite3 \
    libjpeg-dev \
    libopenjp2-7-dev \
    locales \
    cron \
    postgresql-client \
    gettext && rm -rf /var/lib/apt/lists/*;

# Add requirements and install them. We do this unnecessasy rebuilding.
ADD requirements.txt /
ADD requirements-plugins.txt /

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir -r requirements-plugins.txt

WORKDIR /srv/misago

EXPOSE 8000

CMD python manage.py runserver 0.0.0.0:8000
