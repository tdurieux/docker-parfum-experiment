FROM minidocks/base AS latest
LABEL maintainer="Martin Hasoň <martin.hason@gmail.com>"

RUN apk --update --no-cache add poppler poppler-utils pdfgrep pdf2svg@edge && clean
