FROM node:lts-alpine
ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

WORKDIR /usr/local/spotistats-api
RUN mkdir dist

COPY package.json package-lock.json ./
COPY package.json ./dist
COPY . ./

# Install dependenices
RUN npm install

# Generate Prisma typings
RUN npx prisma generate

# Compile everything
RUN npm run compile

EXPOSE 3000

CMD [ "node", "dist/" ]
