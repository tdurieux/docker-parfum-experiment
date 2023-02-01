FROM node:alpine

# Add the following line
ENV CI=true

WORKDIR /app
COPY package.json ./
RUN npm install && npm cache clean --force;
COPY ./ ./

CMD ["npm", "start"]