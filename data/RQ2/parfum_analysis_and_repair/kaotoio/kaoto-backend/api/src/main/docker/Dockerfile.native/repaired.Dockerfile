FROM registry.access.redhat.com/ubi8/ubi-minimal:8.3
WORKDIR /work/
RUN chown 1001 /work \
    && chmod "g+rwX" /work \
    && chown 1001:root /work
COPY --chown=1001:root target/*-runner /work/application

EXPOSE 8081
USER 1001

HEALTHCHECK --interval=3s --start-period=1s CMD curl --fail http://localhost:8081/ || exit 1

CMD ["./application", "-Dquarkus.http.host=0.0.0.0"]