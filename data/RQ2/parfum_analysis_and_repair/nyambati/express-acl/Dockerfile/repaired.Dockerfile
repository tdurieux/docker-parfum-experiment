FROM node:argon

# create project directory
RUN mkdir -p /usr/src/constable && rm -rf /usr/src/constable

# Make it the working directory
WORKDIR /usr/src/constable

# set npm log to warn
RUN npm config set loglevel warn

# Install gulp globasl

RUN npm install -g gulp >/dev/null 2>&1 && npm cache clean --force;

# Install app dependencies
COPY package.json /usr/src/constable/
RUN npm install >/dev/null 2>&1 && npm cache clean --force;

# Bundle project src

COPY . /usr/src/constable

CMD ["npm", "test"]
