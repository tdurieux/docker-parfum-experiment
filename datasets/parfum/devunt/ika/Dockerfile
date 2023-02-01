FROM amazoncorretto:17

USER 1000
WORKDIR /app
COPY --chown=1000:1000 ./app/build/install/app/ .

CMD ["bin/app"]
