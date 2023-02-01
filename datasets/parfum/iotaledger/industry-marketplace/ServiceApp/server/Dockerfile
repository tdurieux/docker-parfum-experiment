FROM node:10.16.2-alpine
RUN apk --no-cache add git python python3 make g++

# Working DIR
WORKDIR /usr/src/app

# Copy everything from current Folder
COPY . ./

# Running required steps to prepare the api prod build
RUN rm db/marketmanager.sqlite3
RUN npm i
RUN npm run build
RUN cd build/src/utils/ && node userHelper.js --create user --role SR --name ServiceRequester --location 52.507339,13.377982

# Remove unneccesary so the docker image doesn't exceeds max size
RUN apk del git python python3 make g++

EXPOSE 4000

# Serve the prod build from the dist folder
CMD ["node", "./build/src/index"]
