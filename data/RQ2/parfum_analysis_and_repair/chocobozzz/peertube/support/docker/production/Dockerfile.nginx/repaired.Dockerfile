FROM nginx:alpine

COPY ./support/docker/production/entrypoint.nginx.sh .
RUN chmod +x entrypoint.nginx.sh

EXPOSE 80 443
ENTRYPOINT []
CMD ["/bin/sh", "entrypoint.nginx.sh"]