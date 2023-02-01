FROM node
RUN npm install -g phantomjs && npm cache clean --force;
ADD . /app
WORKDIR /app
CMD ["/app/tests.sh"]
