FROM node:latest

WORKDIR /opt
RUN git clone https://github.com/llaske/sugarizer
RUN git clone https://github.com/llaske/sugarizer-server
RUN npm install -g grunt-cli && npm cache clean --force;
WORKDIR /opt/sugarizer
RUN npm install --only=dev && npm cache clean --force;
RUN grunt -v --force
WORKDIR /opt/sugarizer-server
RUN npm install --no-optional && npm cache clean --force;
RUN grunt -v --force
RUN cp -r build/* .

EXPOSE 8080
EXPOSE 8039
CMD [ "npm", "run", "start" ]
