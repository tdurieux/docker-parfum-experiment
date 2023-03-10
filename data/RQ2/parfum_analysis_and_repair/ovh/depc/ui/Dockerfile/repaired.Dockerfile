FROM nginx:1.15.10

WORKDIR /app

RUN apt-get update \
        && apt-get -y --no-install-recommends install curl gnupg2 apt-transport-https git && rm -rf /var/lib/apt/lists/*;

# Install Node.js 8
RUN curl -f -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key -o nodesource.gpg.key \
        && apt-key add nodesource.gpg.key
RUN echo 'deb https://deb.nodesource.com/node_8.x stretch main' > /etc/apt/sources.list.d/nodesource.list
RUN apt-get update \
        && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install npm packages
COPY package.json /app/package.json

RUN npm install \
        && npm install bower -g \
        && npm install grunt-cli -g \
        && npm install grunt -g && npm cache clean --force;

# Install bower components
COPY bower.json /app/bower.json

RUN bower install --allow-root

# Copy the source fles
COPY app app

# Build the app
COPY Gruntfile.js /app/Gruntfile.js

# Build HTML/CSS/JS
RUN grunt build \
        && mv /app/dist/* /usr/share/nginx/html

# Start web server
EXPOSE 80
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
