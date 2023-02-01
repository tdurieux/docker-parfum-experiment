FROM cypressbaseelectron
RUN npm i cypress && npm cache clean --force;
RUN $(npm bin)/cypress run