FROM openjdk:10-jre-slim

LABEL name "Lavalink"
LABEL version "3.0.0"
LABEL maintainer "iCrawl <icrawltogo@gmail.com>"

WORKDIR /opt/Lavalink

RUN apt-get update \
&& apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -o Lavalink.jar https://ci.fredboat.com/repository/download/Lavalink_Build/7284:id/Lavalink.jar?guest=1

EXPOSE 7000

ENV SERVER_PORT=7000 \
	SERVER_ADDRESS=0.0.0.0 \
	LAVALINK_SERVER_PASSWORD= \
	LAVALINK_SERVER_SOURCES_YOUTUBE=true \
	LAVALINK_SERVER_SOURCES_BANDCAMP=true \
	LAVALINK_SERVER_SOURCES_SOUNDCLOUD=true \
	LAVALINK_SERVER_SOURCES_TWITCH=true \
	LAVALINK_SERVER_SOURCES_VIMEO=true \
	LAVALINK_SERVER_SOURCES_MIXER=true \
	LAVALINK_SERVER_SOURCES_HTTP=true \
	LAVALINK_SERVER_SOURCES_LOCAL=false \
	LAVALINK_SERVER_BUFFER_DURATION_MS=400 \
	LAVALINK_SERVER_YOUTUBE_PLAYLIST_LOAD_LIMIT=600 \
	SENTRY_DSN= \
	METRICS_PROMETHEUS_ENABLED=false \
	METRICS_PROMETHEUS_ENDPOINT=/metrics

CMD ["java", "-jar", "-Xmx4G", "Lavalink.jar"]
