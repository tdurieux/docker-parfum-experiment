FROM    alpine:3.4
RUN apk -U --no-cache add bash

COPY    setup.sh /usr/bin/setup.sh
WORKDIR /code
CMD     ["/usr/bin/setup.sh"]
