FROM alekzonder/puppeteer:latest

USER root

RUN apt-get update && apt-get install --no-install-recommends -yq ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN yarn global add timecut
RUN yarn global add jest
RUN yarn add puppeteer-screenshot-tester

USER pptruser