FROM node:10.15.3 AS builder

# install chrome for protractor tests
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update && apt-get install --no-install-recommends -yq google-chrome-stable && rm -rf /var/lib/apt/lists/*;

# set working directory
RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json /usr/src/app/package.json
RUN npm install && npm cache clean --force;
RUN npm install -g @angular/cli@1.7.1 && npm cache clean --force;

# add app
COPY src /usr/src/app/src
COPY angular.json /usr/src/app/
COPY tsconfig.json /usr/src/app/

RUN ng build --prod


FROM opentracing/nginx-opentracing

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

## From ‘builder’ stage copy over the artifacts in dist folder to default nginx public folder
COPY --from=builder /usr/src/app/dist/frontend /usr/share/nginx/html

COPY nginx/nginx.conf /etc/nginx/
COPY nginx/zipkin-config.json /etc/

CMD ["nginx", "-g", "daemon off;"]
