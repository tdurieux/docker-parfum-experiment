FROM node:12.0

RUN mkdir /flowgate-build \
  && mkdir /log
VOLUME /build /log
COPY buildui.sh /
RUN chmod o+x buildui.sh

WORKDIR /
ENTRYPOINT [ "bash", "buildui.sh" ]