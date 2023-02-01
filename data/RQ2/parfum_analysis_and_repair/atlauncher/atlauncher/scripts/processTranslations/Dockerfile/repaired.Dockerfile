FROM alpine

RUN apk add --no-cache gettext \
    && mkdir -p /processTranslations/out \
    && mkdir -p /processTranslations/tmp

WORKDIR /processTranslations

ADD convert.sh /processTranslations
ADD in /processTranslations/in

RUN chmod +x convert.sh

RUN ./convert.sh
