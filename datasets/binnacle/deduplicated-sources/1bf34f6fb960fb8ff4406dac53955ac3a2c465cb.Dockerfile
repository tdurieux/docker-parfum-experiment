FROM msaraiva/elixir-dev:1.3.4

RUN apk --update add gcc make libc-dev libgcc && rm -rf /var/cache/apk/*

CMD ["/bin/sh"]
