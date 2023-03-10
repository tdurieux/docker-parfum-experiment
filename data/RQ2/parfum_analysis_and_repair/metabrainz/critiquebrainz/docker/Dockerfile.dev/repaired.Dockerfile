FROM metabrainz/python:3.10-20220315

ENV PYTHONUNBUFFERED 1

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN apt-get update \
     && apt-get install -y --no-install-recommends \
                        build-essential \
                        ca-certificates \
                        cron \
                        git \
                        libpq-dev \
                        libffi-dev \
                        libssl-dev \
                        libxml2-dev \
                        libxslt1-dev \
    && rm -rf /var/lib/apt/lists/*

# PostgreSQL client
RUN curl -f https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
ENV PG_MAJOR 12
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update \
    && apt-get install -y --no-install-recommends postgresql-client-$PG_MAJOR \
    && rm -rf /var/lib/apt/lists/*

# Node
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - \
   && apt-get install --no-install-recommends -y nodejs \
   && rm -rf /var/lib/apt/lists/*

RUN mkdir /code
WORKDIR /code

RUN pip install --no-cache-dir --upgrade pip==21.0.1

# Python dependencies
COPY requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /code/

# Compile translations
RUN pybabel compile -d critiquebrainz/frontend/translations
