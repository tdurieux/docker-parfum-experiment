FROM node:10
WORKDIR /app

# Setup proxy to API used in saleor-platform
RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
COPY ./nginx/dev.conf /etc/nginx/conf.d/default.conf

COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
ARG API_URI
ENV API_URI ${API_URI:-http://localhost:8000/graphql/}

EXPOSE 3000
CMD npm start -- --hostname 0.0.0.0
