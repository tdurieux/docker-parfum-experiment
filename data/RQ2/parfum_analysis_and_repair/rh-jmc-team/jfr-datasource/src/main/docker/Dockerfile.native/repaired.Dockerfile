FROM registry.access.redhat.com/ubi8/ubi-minimal
WORKDIR /work/
COPY target/*-runner /work/application
RUN chmod 775 /work
EXPOSE 8080
ENV LISTEN_HOST=${LISTEN_HOST:-0.0.0.0}
CMD ["./application", "-Dquarkus.http.host=${LISTEN_HOST}"]