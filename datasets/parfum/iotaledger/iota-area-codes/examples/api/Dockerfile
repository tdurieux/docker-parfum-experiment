FROM node:10.13.0-alpine
RUN apk --no-cache add git python make g++

# Working DIR
WORKDIR /usr/src/app

# Copy everything from current Folder
COPY . ./

# Set the env variables
ARG CONFIG_ID
ARG GITHUB_TOKEN
RUN echo "CONFIG_ID=$CONFIG_ID"
RUN echo "GITHUB_TOKEN=$GITHUB_TOKEN"

# We are npm installing from private repos so we need github token with access
RUN git config --global url."https://${GITHUB_TOKEN}:@github.com/".insteadOf "https://github.com/"

# Running required steps to prepare the api prod build
RUN npm install
RUN npm run build

# Remove unneccesary so the docker image doesn't exceeds max size
RUN apk del git python make g++

EXPOSE 4000

# Serve the prod build from the dist folder
CMD ["node", "./dist/index"]