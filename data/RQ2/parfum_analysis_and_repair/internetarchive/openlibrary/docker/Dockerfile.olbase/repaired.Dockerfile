FROM python:3.9.4-slim

ENV LANG en_US.UTF-8

# required for postgres
ENV LC_ALL POSIX

# Create openlibrary users
# We use 999:999 for the openlibrary user. Any volume mounts which require read/write
# access by the container should be set to this user. Ideally we would use a number
# larger than 10,000 to avoid host OS uid/gid conflicts, but this is what we have
# at the moment.
RUN groupadd --system --gid 999 openlibrary \
  && useradd --no-log-init --system -u 999 --gid openlibrary --create-home openlibrary

# Misc OL dependencies
RUN apt-get -qq update && apt-get install --no-install-recommends -y \
    postgresql-client \
    build-essential \
    git \
    libpq-dev \
    libxml2-dev \
    libxslt-dev \
    libffi-dev \
    curl \
    screen \

    vim \
    emacs \

    parallel \

    zip \
    unzip \
    lftp && rm -rf /var/lib/apt/lists/*;

# Install LTS version of node.js
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install Archive.org nginx w/ IP anonymization
USER root
RUN apt-get update && apt-get install -y --no-install-recommends nginx curl \
    # nginx-plus
    apt-transport-https lsb-release ca-certificates wget \
    # log rotation service for ol-nginx
    logrotate && rm -rf /var/lib/apt/lists/*;
RUN wget -O - https://openresty.org/package/pubkey.gpg | apt-key add -
RUN echo "deb http://openresty.org/package/debian $(lsb_release -sc) openresty" \
    | tee /etc/apt/sources.list.d/openresty.list
RUN apt-get update && apt-get -y install --no-install-recommends openresty && rm -rf /var/lib/apt/lists/*;
RUN rm /usr/sbin/nginx
RUN curl -f -L https://archive.org/download/nginx/nginx -o /usr/sbin/nginx
RUN chmod +x /usr/sbin/nginx
# Remove the stock nginx config file
RUN rm /etc/nginx/sites-enabled/default

RUN mkdir -p /var/log/openlibrary /var/lib/openlibrary && chown openlibrary:openlibrary /var/log/openlibrary /var/lib/openlibrary \
 && mkdir /openlibrary && chown openlibrary:openlibrary /openlibrary \
 && mkdir -p /var/lib/coverstore && chown openlibrary:openlibrary /var/lib/coverstore \
 # In order to write to solr-updater's named volume, this needs to be
 # pre-created with the right permissions
 && mkdir -p /solr-updater-data && chown openlibrary:openlibrary /solr-updater-data
WORKDIR /openlibrary

USER openlibrary
COPY --chown=openlibrary:openlibrary requirements*.txt ./
RUN python -m pip install --upgrade pip wheel \
 && python -m pip install --default-timeout=100 -r requirements.txt

# Link the ia CLI binary into /usr/local/bin so that it shows up
# on the PATH. Do this instead of trying to modify the PATH, because
# that causes headaches with su, cron, etc.
USER root
RUN ln -s /home/openlibrary/.local/bin/ia /usr/local/bin/ia
USER openlibrary

COPY --chown=openlibrary:openlibrary package*.json ./
RUN npm ci

COPY --chown=openlibrary:openlibrary . /openlibrary

# run make to initialize git submodules, build css and js files
RUN ln -s vendor/infogami/infogami infogami \
 && make \
 && python -m pip list --outdated
