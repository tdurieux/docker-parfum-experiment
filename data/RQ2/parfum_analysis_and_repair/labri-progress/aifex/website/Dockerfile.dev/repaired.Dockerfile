FROM node as builder

# install python (needed by npm-gyp)
RUN apt-get update && apt-get install --no-install-recommends python make gcc g++ -y && rm -rf /var/lib/apt/lists/*;


# Create app directory
WORKDIR /app

COPY ./package.json /app/package.json
RUN npm install && npm cache clean --force;

# Install app dependencies
COPY ./tsconfig.json /app
COPY ./src /app/src

RUN cd src && npm run compile


FROM node

# Set the working directory to /app
WORKDIR /app

# Install any needed packages specified in requirements.txt=

COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/node_modules /app/node_modules
COPY ./package.json /app/package.json
COPY ./nodemon.json /app/nodemon.json
COPY ./tsconfig.json /app/tsconfig.json


# Run when the container launches
CMD npm run dev

EXPOSE 80
