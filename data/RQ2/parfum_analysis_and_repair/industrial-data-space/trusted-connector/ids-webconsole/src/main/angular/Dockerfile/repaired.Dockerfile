FROM ubuntu:16.04

MAINTAINER Christian Banse <christian.banse@aisec.fraunhofer.de>

RUN apt-get update
RUN apt-get install --no-install-recommends -y git curl unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nodejs nodejs-legacy npm nginx && rm -rf /var/lib/apt/lists/*;

EXPOSE 80

WORKDIR /tmp

# this should hopefully trigger Docker to only update npm/jspm if dependencies have changed
ADD package.json .
RUN npm install --no-optional && npm cache clean --force;
RUN npm run postinstall

# add the rest of the files
ADD . .

# set environment to production
ENV NODE_ENV production

# ng lint before bundling
RUN npm run lint

# build everything for production
RUN npm run bundle

# copy to nginx
RUN cp -r dist/* /var/www/html/

CMD ["nginx", "-g", "daemon off;"]
