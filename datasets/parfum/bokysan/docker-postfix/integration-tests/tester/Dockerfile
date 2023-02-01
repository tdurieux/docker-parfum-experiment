# ---- MAILSEND ----
FROM boky/tool-downloader AS mailsend

RUN  \
    env \
      VERSION='1.0.9' \
      PROJECT='muquit/mailsend-go' \
      POST_INSTALL='cp mailsend-go-dir/mailsend-go /usr/local/bin && chmod +x /usr/local/bin/mailsend-go' \
      DOWNLOAD_TEMPLATE='$( if [[ "${GOARCH}" == "aarch64" ]] || [[ "${GOARCH}" == "amd64" ]]; then GOARCH="64bit"; elif [[ "${GOARCH}" == "arm" ]]; then GOARCH="ARM"; fi; echo "https://github.com/${PROJECT}/releases/download/v${VERSION}/${NAME}_${VERSION}_${GOOS}-${GOARCH}${GOOS_ARCHIVE_STYLE}" )' \
    tool-downloader

# ---- TEST ----
FROM boky/alpine-bootstrap

RUN apk add --no-cache bash bats
COPY --from=mailsend /usr/local/bin/mailsend-go /usr/local/bin/mailsend

WORKDIR /code
ENTRYPOINT ["/usr/bin/bats"]

CMD ["-v"]
