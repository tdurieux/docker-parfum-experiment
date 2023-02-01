FROM debian:9

RUN apt-get update -y
RUN apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libssl-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libcurl4-openssl-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade ca-certificates -y

RUN apt-get install --no-install-recommends -y jq curl && rm -rf /var/lib/apt/lists/*;

RUN useradd ftl-user

RUN mkdir -p /opt/ftl-sdk/vid

RUN chown -R ftl-user:ftl-user /opt/ftl-sdk

WORKDIR /opt/ftl-sdk/vid

ARG VIDEO_URL=https://videotestmedia.blob.core.windows.net/ftl/sintel.h264
RUN wget ${VIDEO_URL}
ARG AUDIO_URL=https://videotestmedia.blob.core.windows.net/ftl/sintel.opus
RUN wget ${AUDIO_URL}

COPY --chown=ftl-user:ftl-user ./CMakeLists.txt /opt/ftl-sdk/CMakeLists.txt
COPY --chown=ftl-user:ftl-user ./libcurl /opt/ftl-sdk/libcurl
COPY --chown=ftl-user:ftl-user ./libjansson /opt/ftl-sdk/libjansson
COPY --chown=ftl-user:ftl-user ./libftl /opt/ftl-sdk/libftl
COPY --chown=ftl-user:ftl-user ./Doxyfile /opt/ftl-sdk/Doxyfile
COPY --chown=ftl-user:ftl-user ./ftl_app /opt/ftl-sdk/ftl_app
COPY --chown=ftl-user:ftl-user ./get-video /opt/ftl-sdk/get-video
COPY --chown=ftl-user:ftl-user ./get-audio /opt/ftl-sdk/get-audio
COPY --chown=ftl-user:ftl-user ./scripts /opt/ftl-sdk/scripts

USER ftl-user

WORKDIR /opt/ftl-sdk

RUN ./scripts/build

COPY --chown=ftl-user:ftl-user ./start-stream /opt/ftl-sdk/start-stream

ENTRYPOINT ["./start-stream"]

