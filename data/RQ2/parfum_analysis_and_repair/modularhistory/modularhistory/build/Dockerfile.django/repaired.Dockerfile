FROM python:3.9-buster

LABEL org.opencontainers.image.source https://github.com/ModularHistory/modularhistory

# https://docs.docker.com/engine/reference/builder/#arg
ARG ENVIRONMENT=dev

# Set environment vars.
ENV \
  PYTHONUNBUFFERED=1 \
  PYTHONFAULTHANDLER=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100

# Add PostgreSQL repo.
RUN wget --quiet https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
  apt-key add ACCC4CF8.asc && \
  echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" >> /etc/apt/sources.list.d/pgdg.list

# Install packages.
RUN apt-get update && apt-get install -y --no-install-recommends \
  dnsutils \
  fdupes \
  gnupg2 \
  graphviz graphviz-dev \
  libenchant-dev \
  libmagic1 \
  postgresql-client-common postgresql-client-14 \
  vim \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir "poetry>=1.0.5"

# Install rclone (for media backup/sync).
RUN curl -f https://rclone.org/install.sh | bash

# Create and enter the working directory.
RUN mkdir -p /modularhistory
WORKDIR /modularhistory

# Install project dependencies.
COPY poetry.lock pyproject.toml /modularhistory/
RUN poetry config virtualenvs.create false
RUN \
  if [ "$ENVIRONMENT" = "dev" ]; then poetry_args=""; pip_args="--dev"; \
  # TODO: Use this logic after it's supported in next Poetry version
  # elif [ "$ENVIRONMENT" = "test" ]; then poetry_args="--without dev"; pip_args="--dev"; \
  # else poetry_args="--without dev,test"; pip_args=""; fi; \
  else poetry_args="--no-dev"; pip_args=""; fi; \
  poetry install --no-interaction --no-ansi --no-root $poetry_args || ( poetry export -f requirements.txt --without-hashes $pip_args -o requirements.txt \
  && pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt)

# Create required directories.
RUN mkdir -p -- \
  /modularhistory/_volumes/static \
  /modularhistory/_volumes/media \
  /modularhistory/_volumes/db/backups \
  /modularhistory/_volumes/db/init \
  /opt/atlas \
  /var/www/nltk_data/corpora

# Download required files.
RUN python -c "import nltk; nltk.download('punkt')" && \
  NLTK_DATA=var/www/nltk_data python -m textblob.download_corpora
# cp -avr nltk_data/ /var/www/

# Add source code.
COPY . /modularhistory/
COPY config/scripts/wait-for-it.sh /usr/local/bin/wait-for-it.sh
COPY config/invoke.yaml /etc/invoke.yaml

# Collect static files.
RUN python manage.py collectstatic --no-input

# Grant necessary permissions to non-root user.
RUN chown -R www-data:www-data /modularhistory && \
  chmod g+w -R /modularhistory/_volumes && \
  chmod +x /usr/local/bin/wait-for-it.sh && \
  chown -R www-data:www-data /var/www/nltk_data && chmod g+w -R /var/www/nltk_data

# Expose port 8000
EXPOSE 8000

# Switch from root to non-root user.
USER www-data

# Specify the default command to run when the container is started.
CMD /bin/bash /modularhistory/config/scripts/init/django.sh
