FROM node:12-alpine
LABEL Name=one-platform-user-group-service \
  Version=0.1.0 \
  maintainer="mdeshmuk@redhat.com"

# Building the user-group microservice
ADD  . /app
WORKDIR /app
RUN npm install --silent && \
  npm run build && npm cache clean --force;

ENV PORT 8080
EXPOSE 8080

CMD [ "node", "dist/bundle.js"]
