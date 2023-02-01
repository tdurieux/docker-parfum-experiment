# base image
FROM node:12.16

# install chrome for protractor tests
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update && apt-get install --no-install-recommends -yq google-chrome-stable && rm -rf /var/lib/apt/lists/*;

# set working directory
WORKDIR /app

# install and cache app dependencies
COPY package.json /app/package.json
RUN npm install && npm cache clean --force;
RUN npm install -g @angular/cli@7.3.9 && npm cache clean --force;

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# add app
COPY . /app

EXPOSE 4200
# start app
CMD ng serve --host 0.0.0.0 --disable-host-check

