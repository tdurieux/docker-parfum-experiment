FROM alpine
RUN apk add --no-cache -U jq
ENTRYPOINT ["jq"]
