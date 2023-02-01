FROM alpine:3.12

RUN apk update && apk add --no-cache bash curl jq
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
  && chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin/kubectl

ADD schedule.sh /bin/schedule

CMD /bin/schedule
