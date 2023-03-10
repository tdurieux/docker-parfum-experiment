FROM golang:alpine AS backend-builder

WORKDIR /app

COPY backend .

RUN go build -o telegram-storage

FROM node:alpine AS frontend-builder

WORKDIR /app

COPY frontend .
RUN yarn && yarn cache clean;

RUN yarn build && yarn cache clean;

FROM alpine AS production
WORKDIR /app

COPY --from=backend-builder /app/telegram-storage .
COPY --from=frontend-builder /app/build ./public

ENTRYPOINT [ "./telegram-storage" ]