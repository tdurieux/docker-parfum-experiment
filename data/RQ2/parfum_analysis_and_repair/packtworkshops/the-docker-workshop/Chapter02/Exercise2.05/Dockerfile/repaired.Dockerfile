# USER example
FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends apache2 -y && rm -rf /var/lib/apt/lists/*;
USER www-data
CMD ["whoami"]

