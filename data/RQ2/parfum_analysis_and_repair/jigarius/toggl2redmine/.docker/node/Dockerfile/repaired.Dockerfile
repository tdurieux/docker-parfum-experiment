FROM node:16-alpine
WORKDIR /app

RUN apk add --no-cache bash

CMD ["tail", "-f", "/dev/null"]
