FROM scratch

COPY ./bin/gobmp-player /gobmp-player
ENTRYPOINT ["/gobmp-player"]