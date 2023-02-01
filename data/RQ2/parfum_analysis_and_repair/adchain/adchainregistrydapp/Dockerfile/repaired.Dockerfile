FROM node:8

EXPOSE 5002

ENV PORT 5002

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app

RUN rm -rf node_modules/
RUN rm -rf build/

RUN npm install --update-binary --no-shrinkwrap && npm cache clean --force;
RUN npm install serve -g && npm cache clean --force;
RUN npm run build

ENTRYPOINT [ "npm" ]
CMD ["run", "start"]
