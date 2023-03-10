FROM node:16-alpine3.15 as website-builder
WORKDIR /www
COPY ./www .
RUN npm i -g pnpm && npm cache clean --force;
RUN pnpm install
RUN pnpm build

FROM golang:1.17
WORKDIR /app
COPY go.* ./
RUN go mod download
COPY . ./
RUN mkdir -p ./static
COPY --from="website-builder" /www/build ./static
RUN go build -o /server cmd/goblin-api/main.go

EXPOSE 3000

CMD [ "/server" ]