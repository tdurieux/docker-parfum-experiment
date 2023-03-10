FROM node:14.13.1 as UI

COPY my-app/package.json /app/my-app/package.json
WORKDIR /app/my-app/
RUN npm install --force -g yarn && npm cache clean --force;
RUN yarn install && yarn cache clean;
COPY my-app /app/my-app
RUN yarn build

FROM golang:1.15.4-buster as build
WORKDIR /app/
COPY go.* /app/
RUN go mod download
COPY . .
RUN  go build
COPY --from=UI /app/my-app/build /app/my-app/build

ARG DB_HOST
ENV DB_HOST=${DB_HOST}

ARG DB_PORT
ENV DB_PORT=${DB_PORT}

ARG DB_NAME
ENV DB_NAME=${DB_NAME}

ARG DB_USER
ENV DB_USER=${DB_USER}

ARG DB_PASSWORD
ENV DB_PASSWORD=${DB_PASSWORD}

# WORKDIR /out
EXPOSE 8000
RUN chmod +x ./audiobook
CMD [ "./audiobook"]