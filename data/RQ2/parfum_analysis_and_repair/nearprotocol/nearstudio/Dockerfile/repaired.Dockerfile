FROM phusion/baseimage:0.11

RUN curl -f -o /tmp/node_setup.sh "https://deb.nodesource.com/setup_11.x"
RUN bash /tmp/node_setup.sh
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    jq \
    nodejs \
    nginx \
    git \
    rsync && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;


# studio
RUN mkdir /studio
COPY . /studio/
WORKDIR /studio
RUN yarn
RUN yarn build
RUN mkdir -p /var/www/html/studio
RUN rsync -ar \
    --exclude node_modules \
    --exclude .git \
    --exclude ops \
    ./ /var/www/html/studio

# nginx
RUN rm /etc/nginx/sites-enabled/default
COPY /scripts/studio.nginx /etc/nginx/sites-enabled/studio
COPY /scripts/init_nginx.sh /etc/my_init.d/
