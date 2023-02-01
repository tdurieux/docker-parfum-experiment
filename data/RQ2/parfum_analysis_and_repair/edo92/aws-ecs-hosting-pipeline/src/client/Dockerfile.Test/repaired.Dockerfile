FROM node:14.15.4-alpine
WORKDIR /app

COPY . ./

RUN npm install --loglevel=error && npm cache clean --force;
RUN npm run build

EXPOSE 3000
CMD ["npm", "run", "test"]