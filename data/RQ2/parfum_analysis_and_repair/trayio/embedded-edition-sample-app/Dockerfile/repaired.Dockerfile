FROM node:6-alpine

COPY ./ /oem
WORKDIR /oem

RUN npm install && npm cache clean --force;

ENTRYPOINT ["/usr/local/bin/npm"]
CMD ["start"]

