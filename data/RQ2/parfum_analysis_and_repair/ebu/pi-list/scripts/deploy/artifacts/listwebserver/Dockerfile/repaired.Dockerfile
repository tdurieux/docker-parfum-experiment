# This is the LIST server's runtime Dockerfile

FROM gcc:10.2

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install --no-install-recommends -yq \
        wireshark-common \
        nginx && rm -rf /var/lib/apt/lists/*;

# Install node
RUN curl -f -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install --no-install-recommends -y \
        ffmpeg \
        zip \
        nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install -g serve && npm cache clean --force;
RUN npm install -g lerna && npm cache clean --force;

ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/usr/local/lib/

ADD app/ /app
ADD lib/ /usr/local/lib
# nginx Configuration
ADD data/config/ /etc/nginx/
# nginx certs
ADD data/certs/ /etc/ssl/certs/
# for static content
RUN mkdir -p /var/data/nginx/
RUN chown -R www-data:www-data /var/data/nginx/

WORKDIR /app/listwebserver/

CMD bash launch.sh
