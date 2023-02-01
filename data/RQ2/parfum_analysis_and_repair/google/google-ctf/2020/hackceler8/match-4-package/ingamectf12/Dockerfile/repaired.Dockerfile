FROM alpine:3
WORKDIR /usr/challenge
COPY ./modded.py .
RUN chmod a+rx ./modded.py
RUN apk add --no-cache socat
RUN apk add --no-cache python3
RUN apk add --no-cache python3-dev
RUN apk add --no-cache gcc
RUN apk add --no-cache py3-pip
RUN apk add --no-cache musl-dev
RUN apk add --no-cache linux-headers
RUN apk add --no-cache gmp-dev
RUN apk add --no-cache mpfr-dev
RUN apk add --no-cache mpc1-dev
RUN python3 -m pip install gmpy2
EXPOSE 1
CMD while true; do socat tcp-l:1,reuseaddr,fork 'exec:/usr/challenge/modded.py'; done
