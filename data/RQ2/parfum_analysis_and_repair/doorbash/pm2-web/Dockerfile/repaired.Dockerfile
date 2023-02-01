FROM alpine:latest
RUN apk add --no-cache --update nodejs npm
RUN npm i pm2 -g && npm cache clean --force;
ADD pm2-web /pm2-web
ADD static /static
EXPOSE 3030
CMD ["pm2-runtime", "--output", "/dev/stdout", "--error", "/dev/stderr", "./pm2-web", "--", "--time", "--app-name", "--actions", ":3030"]