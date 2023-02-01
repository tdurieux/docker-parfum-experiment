# install stage
FROM lts-alpine AS install
WORKDIR /data/app
COPY package*.json .npmrc ./
RUN npm ci

# install production dependence stage
FROM lts-alpine AS install_prod
WORKDIR /data/app
COPY package*.json .npmrc ./
RUN npm ci --production

# build stage
FROM install AS build
WORKDIR /data/app
#COPY --from=install /data/app .
COPY . .
RUN npm run build:noprogress

# run stage