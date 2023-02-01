FROM node:10.1
WORKDIR /usr/src/app
COPY ./reactapp /usr/src/reactapp
RUN npm install && npm cache clean --force;
RUN node run dev
EXPOSE 3000
ENTRYPOINT [ "node", "run dev" ]