FROM pandoc/latex:2.16

RUN apk update && apk upgrade && apk add --no-cache \
    bash \
    dos2unix \
    git \
    python3 \
    py3-pip \ 
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont

COPY ./convert_book.sh /opt/script/

RUN dos2unix /opt/script/convert_book.sh

RUN chmod +x /opt/script/convert_book.sh

ENTRYPOINT ["/opt/script/convert_book.sh"]