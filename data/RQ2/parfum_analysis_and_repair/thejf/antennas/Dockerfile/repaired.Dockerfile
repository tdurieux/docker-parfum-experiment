FROM node:16-alpine
LABEL maintainer="jf.arseneau@gmail.com"

COPY . /antennas
WORKDIR "/antennas"

RUN npm install && npm cache clean --force;

EXPOSE 5004
CMD ["npx", "--yes", "."]
