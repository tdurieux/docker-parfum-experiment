FROM test/nodejs
COPY . /app/
RUN install_node v5.9.0
RUN npm install --unsafe-perm || \
  ((if [ -f npm-debug.log ]; then \
      cat npm-debug.log; \
    fi) && false) && npm cache clean --force;
CMD npm start