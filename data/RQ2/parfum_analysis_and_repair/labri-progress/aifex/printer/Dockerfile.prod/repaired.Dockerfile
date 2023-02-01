FROM node:16 as builder

# install python (needed by npm-gyp)
RUN apt-get update && apt-get install --no-install-recommends python make gcc g++ -y && rm -rf /var/lib/apt/lists/*;


# Create app directory
WORKDIR /app

COPY ./package.json /app/package.json
RUN npm install && npm cache clean --force;

# Install app dependencies
COPY ./tsconfig.json /app
COPY ./src /app/src

RUN run compile


FROM node:16

# Set the working directory to /app
WORKDIR /app

# Install any needed packages specified in requirements.txt=

COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/node_modules /app/node_modules
COPY ./package.json /app/package.json


# Run when the container launches
CMD cd /app && npm start

# Make port available to the world outside this container
EXPOSE 80