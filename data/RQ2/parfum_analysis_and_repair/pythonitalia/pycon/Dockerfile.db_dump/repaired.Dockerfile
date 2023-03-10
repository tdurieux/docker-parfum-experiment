FROM alpine:3.12

RUN apk --no-cache add postgresql-client curl jq bash wget

RUN curl -f -s https://api.github.com/repos/Qovery/replibyte/releases/latest | \
    jq -r '.assets[].browser_download_url' | \
    grep -i 'linux-musl.tar.gz$' | wget -qi -

RUN tar zxf *.tar.gz && rm *.tar.gz
RUN chmod +x replibyte && mv replibyte /usr/local/bin/

CMD ["/bin/bash"]
