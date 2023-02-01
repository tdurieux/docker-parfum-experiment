FROM google/nodejs
RUN git clone https://github.com/couchbaselabs/greenboard.git
WORKDIR greenboard
RUN npm install && npm cache clean --force;
RUN npm install -g bower && npm cache clean --force;
WORKDIR app
RUN git pull
RUN npm install && npm cache clean --force;
RUN bower install  -F  --allow-root
RUN npm install grunt-cli grunt-contrib-concat grunt-contrib-uglify && npm cache clean --force;
RUN ./node_modules/.bin/grunt
WORKDIR ../
COPY start.sh start.sh
EXPOSE 8200
ENTRYPOINT ["./start.sh"]
