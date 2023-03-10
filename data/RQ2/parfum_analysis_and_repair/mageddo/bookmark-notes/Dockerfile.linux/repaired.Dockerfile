FROM alpine as BUILDER
WORKDIR /app
ENV TMP_NAME=/app/bookmark-notes.zip
ENV BOOKMARK_NOTES_VERSION=3.9.1
RUN apk add --no-cache --update curl && \
 curl -f -L "https://github.com/mageddo/bookmark-notes/releases/download/${BOOKMARK_NOTES_VERSION}/bookmark-notes-linux-amd64-${BOOKMARK_NOTES_VERSION}.zip" > $TMP_NAME && \
unzip $TMP_NAME -d /app && rm $TMP_NAME

FROM debian:10-slim
COPY --from=BUILDER /app /app
RUN chmod +x /app/bookmark-notes
CMD /app/bookmark-notes
