FROM node

COPY . /app

WORKDIR /app

RUN npm install -g bower && npm cache clean --force;
RUN npm install -g grunt-cli && npm cache clean --force;

RUN apt-get update && apt-get install --no-install-recommends -y ruby-full && cd app/styles && gem install compass && cd ../.. && rm -rf /var/lib/apt/lists/*;

CMD npm install && bower --allow-root install && grunt serve --force