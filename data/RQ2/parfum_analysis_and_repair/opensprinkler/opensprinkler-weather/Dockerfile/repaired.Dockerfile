FROM node

EXPOSE 3000

RUN groupadd osweather && useradd --no-log-init -m -g osweather osweather
USER osweather

ADD --chown=osweather:osweather . weather

WORKDIR weather
RUN npm install && npm cache clean --force;
RUN npm run compile
CMD npm start

