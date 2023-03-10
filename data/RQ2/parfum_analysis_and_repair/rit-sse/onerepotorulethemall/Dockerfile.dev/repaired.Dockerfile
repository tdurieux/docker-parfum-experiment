FROM node:10

# Build the app
COPY ./ /app
COPY ./package.json /app/package.json

# API_ROOT `--build-arg=api_root=http://localhost:3000/api/v2`
ARG api_root
ENV API_ROOT $api_root

WORKDIR /app
RUN rm -rf node_modules && npm install --warn && npm cache clean --force;

CMD ["npm", "start", "--host", "0.0.0.0"]
