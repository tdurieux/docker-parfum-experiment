FROM oxheadalpha/flextesa:latest
RUN mkdir /app
WORKDIR /app
COPY index.js /app/
RUN apk add --no-cache net-tools nodejs npm
CMD node /app/index.js