FROM ubuntu:14.04
RUN apt update && apt install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
COPY index.html /usr/share/nginx/html/
RUN service nginx restart
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]