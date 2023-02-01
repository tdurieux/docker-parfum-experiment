FROM alpine
RUN apk --no-cache add postgresql py-pip ca-certificates bash && pip install --no-cache-dir s3cmd
COPY backup.sh backup.sh
ENTRYPOINT ["./backup.sh"]
