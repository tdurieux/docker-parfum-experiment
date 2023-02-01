FROM alpine
RUN apk add --no-cache curl bind-tools
COPY demo.sh /
CMD ["tail", "-f", "/dev/null"]
