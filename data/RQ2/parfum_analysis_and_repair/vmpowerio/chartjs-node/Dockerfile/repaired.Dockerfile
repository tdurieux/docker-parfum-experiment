FROM node:5
RUN apt-get update && apt-get install --no-install-recommends libcairo2-dev libpango1.0-dev libgif-dev libjpeg62-turbo-dev build-essential g++ -y && rm -rf /var/lib/apt/lists/*;
# Fix bug https://github.com/npm/npm/issues/9863
RUN cd $(npm root -g)/npm \
  && npm install fs-extra \
  && sed -i -e s/graceful-fs/fs-extra/ -e s/fs\.rename/fs.move/ ./lib/utils/rename.js && npm cache clean --force;
RUN npm install -g grunt-cli mocha-cli && npm cache clean --force;
RUN npm install chart.js@"<=2.6.*" && npm cache clean --force;
# Output debug logs in test output
ENV DEBUG=chartjs-node*
# FILES FOR BUILD
ADD ./test ./test
ADD Gruntfile.js ./Gruntfile.js
ADD ./package.json ./package.json
ADD ./index.js ./index.js
ADD ./.jshintrc ./.jshintrc
ADD ./.jscsrc ./.jscsrc
# END FILES FOR BUILD
RUN npm install && npm cache clean --force;
CMD grunt test
