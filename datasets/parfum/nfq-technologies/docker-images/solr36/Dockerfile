FROM nfqlt/debian-jessie


EXPOSE 8983

CMD exec /entrypoint.sh


ADD build /build
RUN bash /build/setup_docker.sh && rm -Rf /build

