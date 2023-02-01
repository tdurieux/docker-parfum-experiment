FROM cypressbasechrome
RUN npm i cypress && npm cache clean --force;
RUN google-chrome --version
RUN $(npm bin)/cypress run --browser chrome
