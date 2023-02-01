# Pull base image
FROM python:3.9.13

# Set environment varibles,
ENV PYTHONDONTWRITEBYTECODE 1
# brings output to the terminal
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /code

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir pipenv

COPY Pipfile Pipfile.lock /code/
RUN pipenv install --dev --system

# Install Node and npm dependencies
RUN \
  apt-get update && \
  apt-get install --no-install-recommends -yqq apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN \
  echo "deb https://deb.nodesource.com/node_14.x buster main" > /etc/apt/sources.list.d/nodesource.list && \
  wget -qO- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
  apt-get update && \
  apt-get install --no-install-recommends -yqq nodejs && \
  pip install --no-cache-dir -U pip && pip install --no-cache-dir pipenv && \
  npm i -g npm@^8 && \
  pip --version && \
  npm -v && \
  node -v i && \
  rm -rf /var/lib/apt/lists/* && npm cache clean --force;

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied

COPY package*.json /code/

RUN npm install && npm cache clean --force;

# Install gettext for i18n
RUN apt-get update && apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*;

# Copy project
COPY . /code/
