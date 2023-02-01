#FROM arm64v8/nginx
FROM nginx

RUN apt-get update -y
RUN apt install -y telnet

CMD [nginx, '-g', 'daemon off;']
