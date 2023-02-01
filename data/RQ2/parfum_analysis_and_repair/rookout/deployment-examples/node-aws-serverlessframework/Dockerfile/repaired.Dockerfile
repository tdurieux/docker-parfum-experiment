# use your node version
FROM node:14.17.0

# install serverless framework
RUN npm install -g serverless && npm cache clean --force;

# make room for our application in /app
RUN mkdir app
WORKDIR /app

# copy package dependencies
COPY package.json package-lock.json ./

# install app dependencies
RUN npm install && npm cache clean --force;

# copy our application contents
COPY . .

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# severless preperations here (e.g: setting aws permissions)
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# deploy serverless
CMD sls deploy