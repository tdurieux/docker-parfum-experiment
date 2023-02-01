FROM debian:stable-20210621
RUN wget https://bing.com
RUN curl -f https://google.com

FROM baseimage:1.0
USER mike
RUN curl -f https://bing.com
