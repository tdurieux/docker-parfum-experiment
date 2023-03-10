# pull official base image
FROM registry.redhat.io/rhel8/nodejs-14:1-72

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
# ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY ["package.json", "package-lock.json", "./"]

RUN npm install --silent && npm cache clean --force;

# add app
COPY . ./

# start app
CMD ["npm", "start"]