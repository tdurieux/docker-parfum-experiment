FROM node:14.2.0

WORKDIR /app

ENV PORT 3000
EXPOSE 3000

CMD ["yarn", "start"]