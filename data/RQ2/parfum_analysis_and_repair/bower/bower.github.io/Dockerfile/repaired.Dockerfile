FROM node:5.10.0

RUN mkdir -p /opt/code
WORKDIR /opt/code

RUN npm install -g bower && \
    npm install -g grunt-cli && \
    apt-get update && \
    apt-get install --no-install-recommends -y ruby ruby-dev && \
    gem install jekyll && \
    gem install jekyll-paginate && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
