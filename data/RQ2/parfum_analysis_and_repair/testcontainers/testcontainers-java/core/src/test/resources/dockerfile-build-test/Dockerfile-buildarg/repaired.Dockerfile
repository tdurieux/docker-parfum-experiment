FROM alpine:3.14
ARG CUSTOM_ARG
RUN echo "${CUSTOM_ARG}" > /test.txt