FROM madnificent/ember:2.18.0 as ember

COPY /ember /app

RUN cd /app && npm install && bower install && npm cache clean --force;

WORKDIR /app

VOLUME /app/app

RUN mkdir -p /dist
VOLUME /dist

CMD ember build --watch --output-path=/dist
