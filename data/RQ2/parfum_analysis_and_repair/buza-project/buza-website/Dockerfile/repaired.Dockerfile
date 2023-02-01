FROM python:3.6

# The enviroment variable ensures that the python output is set straight
# to the terminal with out buffering it first
ENV PYTHONUNBUFFERED 1

RUN mkdir /buza-website

RUN set -ex; \
  apt-get update; \
  apt-get install -y --no-install-recommends apt-transport-https; rm -rf /var/lib/apt/lists/*; \
  curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -; \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" >/etc/apt/sources.list.d/yarn.list; \
  curl -f -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh; \
  bash nodesource_setup.sh; \
  apt-get update; \
  apt-get install --no-install-recommends -y python3-pip yarn nodejs


WORKDIR /buza-website

# Copy the current directory contents into the container
COPY . /buza-website

RUN set -ex; \
  pip install --no-cache-dir pipenv; \
  yarn; \
  cp -p .env.example .env;

ENV DJANGO_SETTINGS_MODULE="buza.settings_docker"

RUN pipenv install --system --deploy; \
  pipenv run django-admin migrate

EXPOSE 8000
