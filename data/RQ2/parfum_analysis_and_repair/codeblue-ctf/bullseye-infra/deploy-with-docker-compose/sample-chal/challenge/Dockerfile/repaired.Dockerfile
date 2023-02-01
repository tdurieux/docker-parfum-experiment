FROM alpine

RUN apk --update --no-cache add netcat-openbsd bash

CMD ["bash", "-c", "cat /flag | nc -l 8080"]
