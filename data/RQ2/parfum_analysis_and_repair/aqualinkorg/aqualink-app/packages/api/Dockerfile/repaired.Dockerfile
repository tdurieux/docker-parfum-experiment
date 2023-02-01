FROM node:16

# Install netcdf
RUN apt update
RUN apt install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN sudo apt install --no-install-recommends -y libnetcdf-dev && rm -rf /var/lib/apt/lists/*;

RUN yarn global add typescript && yarn cache clean;
RUN yarn global add ts-node && yarn cache clean;

# Run application
ENV NODE_ENV=production
WORKDIR /app

# TODO - Find a way to get the yarn.lock which is "out of context".
# Because we are in a sub-package it is located at ../../yarn.lock
COPY ["package.json", "yarn.lock", "./"]

RUN yarn install --production && yarn cache clean;

COPY . .

CMD [ "yarn", "start" ]
