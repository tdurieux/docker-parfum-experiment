FROM node:0.12.2

COPY . /app

RUN apt-get update && apt-get install --no-install-recommends -y ruby-compass && rm -rf /var/lib/apt/lists/*;
RUN cd /app; npm install -g bower grunt-cli; npm cache clean --force; npm install; bower install --allow-root;

WORKDIR /app

EXPOSE 5000

CMD ["grunt", "serve"]

