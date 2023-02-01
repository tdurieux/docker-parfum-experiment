FROM node:18

WORKDIR /ob-web/

RUN mkdir ./front
COPY ./front ./front
RUN cd front && npm install && npm cache clean --force;

RUN mkdir ./backend
COPY ./backend ./
RUN cd backend && npm install && npm cache clean --force;

RUN cd front && npm run build

EXPOSE 8006
CMD [ "npm", "run", "dev" ]
