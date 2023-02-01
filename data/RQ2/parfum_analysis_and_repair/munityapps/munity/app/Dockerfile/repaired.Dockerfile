FROM nginx:1.19

WORKDIR /var/www

RUN apt update && apt install --no-install-recommends -y git npm nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;

COPY . .

RUN yarn install && yarn cache clean;
RUN yarn build && yarn cache clean;

# COPY ./build /var/www/build
COPY ./server.conf /etc/nginx/conf.d/default.conf
