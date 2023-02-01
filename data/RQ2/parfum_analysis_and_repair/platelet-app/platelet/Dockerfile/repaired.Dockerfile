# pull official base image
FROM node:16

# Install dependency for canvas
RUN apt-get update && apt-get install --no-install-recommends -y build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev && rm -rf /var/lib/apt/lists/*;

# set working directory
WORKDIR .

# add `/node_modules/.bin` to $PATH
ENV PATH /node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm install && npm cache clean --force;
RUN npm install react-scripts@4.0.3 && npm cache clean --force;

# add app
COPY . ./

# start app
CMD ["npm", "start"]

