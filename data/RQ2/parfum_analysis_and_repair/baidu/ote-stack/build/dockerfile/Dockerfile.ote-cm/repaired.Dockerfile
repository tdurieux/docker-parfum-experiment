FROM alpine

COPY ote_controller_manager /usr/local/bin/

WORKDIR /usr/local/bin/
ENTRYPOINT ["./ote_controller_manager"]