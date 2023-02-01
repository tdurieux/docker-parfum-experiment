FROM 174235647593.dkr.ecr.eu-central-1.amazonaws.com/keenethics:node-new
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .

RUN npm run build
EXPOSE 3000
CMD npm run start
