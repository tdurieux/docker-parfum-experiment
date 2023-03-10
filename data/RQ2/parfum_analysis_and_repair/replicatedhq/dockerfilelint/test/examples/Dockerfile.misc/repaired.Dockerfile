# This Dockerfile is designed to test error paths in index.js
# Don't model anything after this :)

CMD ["test"]
FROM ubuntu
FROM ubuntu:latest
this is not a command

MAINTAINER test

ADD
RUN sudo rm /tmp/1
RUN apt-get upgrade
RUN apt-get install -y --no-install-recommends python && rm -rf /var/lib/apt/lists/*;
RUN apt-get dist-upgrade
RUN apt-get update -y
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		curl \
	&& rm -rf /var/lib/apt/lists/*
RUN apk add --no-cache python-pip
RUN apk add --no-cache python-dev build-base wget && apk del python-dev build-base wget

EXPOSE 80a
EXPOSE 80:80
VOLUME /tmp
ENV testsomething=test value
LABEL test="value value" test='value value' test=value\ value
LABEL test value
COPY ./test /tmp
USER ubuntu ubuntu
WORKDIR in valid
ARG test
ONBUILD RUN echo test
STOPSIGNAL SIGKILL
ADD /test* /test2
CMD ["bash"]
SHELL ["/bin/sh", "-c"]
ENTRYPOINT ["bash"]
