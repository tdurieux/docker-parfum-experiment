FROM mwendler/wget
run apk update && apk add --no-cache bash
WORKDIR /output

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
