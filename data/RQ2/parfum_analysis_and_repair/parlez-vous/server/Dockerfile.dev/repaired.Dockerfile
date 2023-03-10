# Creates the image to run the server locally

FROM node:14.15-stretch

# Create app directory
WORKDIR /usr/app

# Install app dependencies first to make use of docker layer caching
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
COPY schema.prisma ./
# post-install cmd automatically generates prisma files
RUN npm install && npm cache clean --force;
# Changing any of these files shouldn't affect npm install output
COPY src/ ./src
COPY bootstrap-server-dev.sh ./
COPY migrations ./migrations
COPY tsconfig.json ./
# build the bundle initially to ensure nodemon can run immediately without errors
RUN npm run build

CMD [ "/usr/app/bootstrap-server-dev.sh" ]
