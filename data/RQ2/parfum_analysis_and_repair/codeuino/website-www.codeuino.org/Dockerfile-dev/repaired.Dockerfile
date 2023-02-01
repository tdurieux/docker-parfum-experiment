FROM node:12.2.0-alpine
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json /app/package.json
RUN npm install --silent && npm cache clean --force;
RUN npm install react-scripts@latest -g --silent && npm cache clean --force;
CMD ["npm", "start"]
