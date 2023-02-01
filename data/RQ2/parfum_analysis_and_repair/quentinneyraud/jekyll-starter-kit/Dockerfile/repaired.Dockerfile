FROM nginx

# Node
RUN apt-get update && apt-get install --no-install-recommends -y curl jekyll git gnupg && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /home/tmp
WORKDIR /home/tmp

# keep node_modules cache if package.json is untouched
COPY package.json /home/tmp
RUN npm install && npm cache clean --force;

COPY . /home/tmp
RUN npm run build

RUN cp -R /home/tmp/public/* /usr/share/nginx/html/
