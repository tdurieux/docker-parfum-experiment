FROM nginx

RUN apt-get update
RUN apt-get -yqq --no-install-recommends install curl git-core vim build-essential && rm -rf /var/lib/apt/lists/*;

# install node
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get -yqq --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

# contains app source
ARG SRC_PATH

# nginx site config file
ARG NGINX_CONFIG=./frontend.conf

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

ARG NODE_PATH=/src/src
ENV NODE_PATH=${NODE_PATH}

ARG REACT_APP_ENV=staging
ENV REACT_APP_ENV=${APP_ENV}

# Create the build
WORKDIR /src
COPY ${SRC_PATH} .
RUN npm install --only=dev && npm cache clean --force;
RUN npm install && npm cache clean --force;
RUN npm run build
RUN mv ./build/* /usr/share/nginx/html
RUN rm -rf /src/*

COPY ${NGINX_CONFIG} /frontend.conf

ARG API_URL
ENV API_URL=${API_URL}

EXPOSE 8080
CMD /bin/bash -c 'envsubst \$API_URL < /frontend.conf > /etc/nginx/conf.d/default.conf && nginx -g "daemon off;"'
