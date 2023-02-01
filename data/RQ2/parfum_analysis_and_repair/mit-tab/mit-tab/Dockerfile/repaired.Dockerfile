FROM python:3.7

# install dependenices
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y vim default-mysql-client && rm -rf /var/lib/apt/lists/*;

WORKDIR /var/www/tab

COPY Pipfile ./
COPY Pipfile.lock ./
COPY package.json ./
COPY package-lock.json ./
COPY manage.py ./
COPY setup.py ./
COPY webpack.config.js ./
COPY settings.yaml ./
COPY ./mittab ./mittab
COPY ./bin    ./bin
COPY ./assets ./assets

RUN pip install --no-cache-dir pipenv
RUN pipenv install --deploy --system

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install && npm cache clean --force;
RUN ./node_modules/.bin/webpack --config webpack.config.js --mode production
RUN python manage.py collectstatic --noinput

RUN mkdir /var/tmp/django_cache

EXPOSE 8000
CMD ["/var/www/tab/bin/start-server.sh"]
