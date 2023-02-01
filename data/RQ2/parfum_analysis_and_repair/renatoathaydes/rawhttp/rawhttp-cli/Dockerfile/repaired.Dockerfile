FROM findepi/graalvm AS rawhttp-native

WORKDIR /app
ENV APP_NAME rawhttp

ADD build/libs/${APP_NAME}.jar /app

RUN apt-get update && apt-get install --no-install-recommends -y gcc zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN native-image -jar ${APP_NAME}.jar --static

# Create minimal executable image with the native rawhttp command

FROM busybox:glibc

COPY --from=rawhttp-native /app/rawhttp rawhttp

ENTRYPOINT ["/rawhttp"]
