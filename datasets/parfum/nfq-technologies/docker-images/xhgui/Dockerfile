FROM nfqlt/php81-dev

EXPOSE 80
CMD exec /entrypoint.sh

ADD build /build
RUN bash /build/setup_docker.sh && rm -Rf /build
