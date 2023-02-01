FROM python:3.8.6

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install nodejs 12.x
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install --no-install-recommends -y nodejs \
    && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install dependencies
RUN npm install -g serverless && npm cache clean --force;
COPY package.json .
RUN npm install && npm cache clean --force;

COPY . .
