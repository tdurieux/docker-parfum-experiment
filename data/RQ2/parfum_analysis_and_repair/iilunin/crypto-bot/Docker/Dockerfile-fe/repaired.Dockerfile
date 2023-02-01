FROM node:16
ENV PATH /usr/src/app/node_modules/.bin:$PATH
# set working directory
RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# add `/usr/src/app/node_modules/.bin` to $PATH


# install and cache app dependencies
RUN npm install -g npm && npm cache clean --force;
COPY ./admin/package.json /usr/src/app/package.json
COPY ./admin/package-lock.json /usr/src/app/package-lock.json
RUN npm install && npm cache clean --force;
RUN npm install -g @angular/cli && npm cache clean --force;

# add app
COPY ./admin /usr/src/app

RUN ng build --prod --output-path release