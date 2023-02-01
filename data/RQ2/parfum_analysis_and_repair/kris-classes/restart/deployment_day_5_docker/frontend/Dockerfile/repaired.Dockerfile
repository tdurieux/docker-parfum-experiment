FROM node

# set working directory
WORKDIR /app

COPY . ./

RUN git clone https://github.com/kris-classes/restart.git
WORKDIR /app/restart/react_day_7/
RUN npm install && npm cache clean --force;
RUN npm run build
RUN npm install -g serve && npm cache clean --force;

ENTRYPOINT [ "serve", "-s", "build" ]