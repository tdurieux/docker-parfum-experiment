FROM scratch
COPY ./build/linux/gliderlabs-sigil-amd64 /gliderlabs-sigil
ENTRYPOINT ["/gliderlabs-sigil"]