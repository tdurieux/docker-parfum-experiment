FROM node:14

# Install global packages
RUN npm install -g gulp-cli mocha && npm cache clean --force;

# Copy package.json and package-lock.json into image, then install
# dependencies.
WORKDIR /usr/src/habitica
COPY ["package.json", "package-lock.json", "./"]
RUN npm install && npm cache clean --force;

# Copy the remaining source files in.
COPY . /usr/src/habitica
RUN npm run postinstall
