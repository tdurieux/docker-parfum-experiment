FROM node:11.15.0
COPY . /test
WORKDIR /test
RUN npm install && npm cache clean --force;
CMD ["/bin/bash", "-c", "/test/tests/resources/run_tests.sh"]
