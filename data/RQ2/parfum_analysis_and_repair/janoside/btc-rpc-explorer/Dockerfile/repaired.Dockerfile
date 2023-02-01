FROM node:16 as builder
WORKDIR /workspace
COPY . .
RUN npm install && npm cache clean --force;

FROM node:16-alpine
WORKDIR /workspace
COPY --from=builder /workspace .
RUN apk --update --no-cache add git
CMD npm start
EXPOSE 3002
