FROM peach-melpa:latest

ENV DISPLAY=":13"

RUN apk add --no-cache emacs-x11 xvfb imagemagick curl

RUN chmod +x ./install-font.sh
RUN ./install-font.sh

COPY wrapper.sh .
RUN chmod +x ./wrapper.sh

ENTRYPOINT ["/bin/sh", "./wrapper.sh"]
