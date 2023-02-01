FROM node:17-alpine3.12

WORKDIR /app

COPY . .

RUN npm install && npm cache clean --force;

CMD ["npm", "run", "storybook:docker"]