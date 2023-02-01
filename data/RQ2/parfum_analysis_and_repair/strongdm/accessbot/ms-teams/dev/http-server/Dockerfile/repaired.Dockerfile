FROM nginx

WORKDIR /server

RUN apt update -y --no-install-recommends && apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*; # Install NodeSource Node.js 16.x repo
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -

RUN npm install -g ngrok && npm cache clean --force;

COPY nginx.conf /etc/nginx/conf.d/accessbot.conf
COPY entrypoint.sh /docker-entrypoint.d/99-accessbot.sh
