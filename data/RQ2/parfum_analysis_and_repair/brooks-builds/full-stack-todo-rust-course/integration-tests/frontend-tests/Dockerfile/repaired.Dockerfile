FROM node:16
RUN apt-get update && apt-get install --no-install-recommends -y xvfb libnss3 libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 libgbm1 libasound2 && rm -rf /var/lib/apt/lists/*;
RUN npm i -g cypress && npm cache clean --force;
VOLUME /code
WORKDIR /code
CMD cypress run --no-exit