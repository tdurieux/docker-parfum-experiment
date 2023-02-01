FROM node:8.11.2

# install chrome for protractor tests
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update && apt-get install --no-install-recommends -yq google-chrome-stable && rm -rf /var/lib/apt/lists/*;

WORKDIR /code

# Add dependencies
ADD ./package.json /code
ADD ./bower.json /code
ADD ./gulpfile.js /code
ADD ./.eslintrc /code
ADD ./karma.conf.js /code

# Install Prerequisites
RUN npm install -g bower gulp && npm cache clean --force;

RUN npm link gulp

RUN npm cache clean --force -f
RUN npm install && npm cache clean --force;
RUN npm install -g karma-cli && npm cache clean --force;
RUN npm install -g qs && npm cache clean --force;
RUN bower install --allow-root
RUN apt-get install --no-install-recommends -y libxss1 && rm -rf /var/lib/apt/lists/*;

CMD ["gulp", "dev:runserver"]

EXPOSE 8888
