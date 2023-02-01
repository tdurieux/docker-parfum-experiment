# RUN docker build . -t dashboard
# docker tag dashboard:latest featureformcom/dashboard:latest
# docker push featureformcom/dashboard:latest

FROM node:16-alpine
COPY ./dashboard ./dashboard
WORKDIR ./dashboard
RUN npm install --production
RUN npm run build
RUN npm uninstall -g serve
RUN npm i -g serve
RUN yarn global add serve
RUN ls
EXPOSE 3000
ENTRYPOINT serve -s build