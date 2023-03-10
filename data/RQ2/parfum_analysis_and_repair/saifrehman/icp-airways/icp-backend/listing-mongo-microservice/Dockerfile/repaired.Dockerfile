FROM node:9.8.0
WORKDIR /app
COPY . /app
RUN cd /app; npm install && npm cache clean --force;
EXPOSE 7000
RUN npm i -g webpack webpack-cli && npm cache clean --force;
RUN webpack-cli
RUN groupadd -g 999 appuser && \
    useradd -r -u 999 -g appuser appuser
USER appuser
CMD [ "node", "dist/bundle-be.js" ]