FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y curl nginx && rm -rf /var/lib/apt/lists/*;
COPY index.html /var/www/html/index.html
RUN service nginx restart
EXPOSE 80
CMD  ["nginx","-g","daemon off;"]
