FROM node:12.16-alpine3.11

WORKDIR /home/app/packages/client

ENTRYPOINT ["yarn"]
CMD ["start"]