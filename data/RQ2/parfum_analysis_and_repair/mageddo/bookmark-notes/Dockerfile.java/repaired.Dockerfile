FROM alpine AS BUILDER
WORKDIR /app
ENV TMP_NAME=/app/bookmark-notes.zip
ENV BOOKMARK_NOTES_VERSION=3.9.1
RUN apk add --no-cache --update curl && \
 curl -f -L "https://github.com/mageddo/bookmark-notes/releases/download/${BOOKMARK_NOTES_VERSION}/bookmark-notes-${BOOKMARK_NOTES_VERSION}.zip" > $TMP_NAME && \
unzip $TMP_NAME -d /app && rm $TMP_NAME

FROM adoptopenjdk:11-jre-hotspot
COPY --from=BUILDER /app /app
CMD /app/bookmark-notes/bin/bookmark-notes
