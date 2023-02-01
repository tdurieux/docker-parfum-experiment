FROM nginx:1.23.0

RUN apt-get update && apt-get upgrade -y

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN \
  apt-get install --no-install-recommends -y \
  libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 \
  libxss1 libasound2 libxtst6 xauth xvfb g++ make && rm -rf /var/lib/apt/lists/*;

WORKDIR /src/build-your-own-radar
COPY package.json ./
RUN npm install && npm cache clean --force;

COPY . ./

# Override parent node image's entrypoint script (/usr/local/bin/docker-entrypoint.sh),
# which tries to run CMD as a node command
ENTRYPOINT []
CMD ["./build_and_start_nginx.sh"]
