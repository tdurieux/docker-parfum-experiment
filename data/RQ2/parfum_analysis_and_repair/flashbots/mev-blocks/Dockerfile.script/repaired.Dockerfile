FROM node:14

WORKDIR /usr/src/app

RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install

COPY package.json ./
COPY yarn.lock ./

RUN yarn install && yarn cache clean;

COPY . .


EXPOSE 31080

CMD [ "yarn", "run", "dump-s3"]
