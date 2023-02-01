FROM qfarm/webapp

ADD webapp /webapp

RUN cd /webapp && \
    npm install && \
    npm run build && npm cache clean --force;

CMD ["http-server", "/webapp/dist/", "-d", "-p 9000"]
