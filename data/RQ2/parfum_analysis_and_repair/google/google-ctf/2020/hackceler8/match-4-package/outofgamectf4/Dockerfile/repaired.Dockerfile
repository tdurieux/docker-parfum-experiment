FROM alpine:3
WORKDIR /usr/challenge
COPY ./runner .
COPY ./controller.py .
COPY ./challenges/sort.py ./challenges/
RUN chmod a+rx ./runner ./controller.py
RUN chmod a+r ./challenges/sort.py
RUN apk add --no-cache nasm
RUN apk add --no-cache socat
RUN apk add --no-cache python3
EXPOSE 4568
CMD while true; do socat tcp-l:4568,reuseaddr,fork 'exec:/usr/challenge/controller.py sort'; done
