FROM alpine:3.12
RUN apk add --no-cache curl iproute2 iputils jq
ADD bridget.sh /bin/bridget.sh
CMD /bin/bridget.sh
