FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends nginx -y && rm -rf /var/lib/apt/lists/*;
COPY index.html /var/www/html/
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]