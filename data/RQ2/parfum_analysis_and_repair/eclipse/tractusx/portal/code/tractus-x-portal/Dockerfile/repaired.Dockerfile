# Step 1
FROM node:10-alpine as build-step
RUN mkdir /app
WORKDIR /app
COPY package.json /app
RUN npm install && npm cache clean --force;
COPY . /app
RUN npm run build

# Stage 2
FROM nginx
RUN apt-get update && apt-get install --no-install-recommends -y curl && apt-get clean && rm -rf /var/lib/apt/lists/*;
COPY --from=build-step /app/build /usr/share/nginx/html