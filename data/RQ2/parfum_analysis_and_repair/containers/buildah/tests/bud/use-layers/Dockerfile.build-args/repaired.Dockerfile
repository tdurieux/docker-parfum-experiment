FROM alpine
ARG user
RUN echo $user | base64
RUN touch /tmp/hello