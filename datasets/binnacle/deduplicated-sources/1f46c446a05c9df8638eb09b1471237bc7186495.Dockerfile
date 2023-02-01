# this file only includes the dist folder, to support cloud deployment for server side rendering
# FROM node:10.15.0-alpine as buildContainer

# WORKDIR /app
# COPY ./package.json ./package-lock.json /app/
# RUN npm install
# COPY . /app
# RUN npm run build:ssr

FROM node:10.15.0-alpine

WORKDIR /app
# COPY --from=buildContainer /app/dist /app/dist
COPY ./dist /app/dist

# Expose the port the app runs in
EXPOSE 4000

# Serve the app
CMD ["node", "dist/universalServer"]
