# Available at cshubnl/shared
ARG BASE_IMAGE=cshub-shared

# build stage
FROM $BASE_IMAGE as build-server

# Set the current working directory
WORKDIR /app/cshub-server

# Copy package files
COPY package.json ./
COPY yarn.lock ./

# Install dependencies and subsequently remove the build dependencies
RUN apk add python make g++ --no-cache -t builddep && yarn install && apk del builddep && yarn cache clean

# Copy source files
COPY . .
COPY ./src/SettingsBaseline.ts ./src/settings.ts

# Install TSC, Compiles TS, Remove TSC
RUN yarn global add typescript@4.0.3 && tsc && yarn global remove typescript && yarn cache clean
RUN mkdir -p /app/cshub-server/dist/cshub-server/src/endpoints/post/assets
COPY ./src/endpoints/post/assets/* /app/cshub-server/dist/cshub-server/src/endpoints/post/assets/

CMD ["node", "dist/cshub-server/src/index.js"]
