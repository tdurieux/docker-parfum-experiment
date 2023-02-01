FROM alpine:latest
COPY civo /usr/local/bin/civo

RUN apk add --no-cache --update ca-certificates \
    && apk add --no-cache --update -t deps curl \
	&& curl -f -L "https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl \
	&& chmod +x /usr/local/bin/kubectl

ENTRYPOINT ["civo", "--config", "/.civo.json"]
CMD [ "version" ]
