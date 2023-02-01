FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y curl build-essential nginx && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install yarn -g && npm cache clean --force;

WORKDIR /app

COPY . .

RUN yarn

ADD ./nginx.conf /etc/nginx/nginx.conf

RUN yarn build

CMD ["nginx", "-g", "daemon off;"]