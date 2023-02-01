FROM node
WORKDIR /home/app/static
RUN apt-get update && apt-get install --no-install-recommends -y ruby ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install sass
RUN npm install -g bower && npm cache clean --force;
RUN npm install -g gulp && npm cache clean --force;
