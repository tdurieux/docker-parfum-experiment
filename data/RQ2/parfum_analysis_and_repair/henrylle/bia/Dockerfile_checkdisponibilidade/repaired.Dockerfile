FROM alpine
ENV URL=https://www.google.com.br
RUN apk add --no-cache curl
ENTRYPOINT echo "Checando Site: $URL";while sleep 5; do curl -o /dev/null -s -w "Status: %{http_code} - Hora: $(date +%H:%M:%S)\n" $URL; done