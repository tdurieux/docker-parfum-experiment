FROM node:12.16-alpine3.11

WORKDIR /home/app/packages/server

ENTRYPOINT ["yarn"]
CMD ["dev"]