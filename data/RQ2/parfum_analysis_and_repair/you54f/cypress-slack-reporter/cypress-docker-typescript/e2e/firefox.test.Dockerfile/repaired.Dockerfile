FROM cypressbasefirefox
RUN npm i cypress && npm cache clean --force;
RUN firefox --version
RUN $(npm bin)/cypress run --browser firefox