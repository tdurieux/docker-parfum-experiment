FROM node:alpine

WORKDIR /usr/app

COPY package.json .
RUN npm install && npm cache clean --force;
COPY . .

CMD ["npm", "run", "start"]

# Commands to use:
#
# Build from a file
#   docker build -f Dockerfile.dev .
#
# Map the ports (local:remote), use the remote volume for node_modules (do not try to map/reference)
# and map/reference the other directories/files
#   docker run -p 3000:3000 -v /usr/app/node_modules -v $(pwd):/usr/app 81275fec7a56
#
# or use docker-compose instead :)
