FROM node
COPY topcoder-app /topcoder-app

WORKDIR topcoder-app

RUN npm i && npm cache clean --force;

COPY constants.coffee /topcoder-app/node_modules/appirio-tech-webpack-config/constants.coffee

CMD npm start

