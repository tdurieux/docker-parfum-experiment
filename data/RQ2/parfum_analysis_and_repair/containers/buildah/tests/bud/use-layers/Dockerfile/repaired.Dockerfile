FROM alpine
RUN mkdir /hello
VOLUME /var/lib/testdata
RUN touch file.txt
EXPOSE 8080
ADD https://github.com/containers/buildah/blob/main/README.md /tmp/
ENV foo=bar