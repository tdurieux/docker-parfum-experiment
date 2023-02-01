FROM alpine as runtime
COPY "*" "/bin/"
ARG ENTRY
ENV ENTRY=${ENTRY}

RUN apk add --no-cache -U wireguard-tools

CMD /bin/${ENTRY}