FROM node:10

ENV NODE_ENV production
# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY . .

RUN npm install -g typescript && npm cache clean --force;
RUN npm install && npm cache clean --force;
RUN npm install --dev && npm cache clean --force;

EXPOSE 3000

CMD ["npm", "run", "prod"]