FROM node AS build

ADD ./ /app
WORKDIR /app
RUN npm install && npm run build && npm cache clean --force;

FROM node

EXPOSE 5000
COPY --from=build /app/build /app
RUN npm install -g serve && npm cache clean --force;

CMD serve -s /app
