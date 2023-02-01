FROM alpine

RUN apk add --no-cache curl bash sed grep
RUN curl -f https://luet.io/install.sh | sh

ENV LUET_YES=true
ENV LUET_NOLOCK=true
RUN luet install repository/mocaccino-extra repository/mocaccino-desktop repository/mocaccino-os-commons
RUN luet install -qy utils/jq utils/yq extension/filter

ENTRYPOINT /bin/bash