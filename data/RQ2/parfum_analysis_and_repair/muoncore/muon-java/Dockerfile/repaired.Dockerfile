FROM node:4.4.3

RUN apt-get install -y --no-install-recommends libstdc++6 && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

CMD ["node_modules/mocha/bin/mocha", "-R", "mocha-multi", "--reporter-options", "mocha-teamcity-reporter=-,xunit=test-results/xunit.xml", "--recursive"]
