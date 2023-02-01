FROM alpine:edge

ADD  https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.x86_64 /bin/ttyd
COPY ./build/k9s/execs/ekz-ui /bin/ekz-ui
COPY config.yml /root/.k9s/config.yml
COPY hotkey.yml /root/.k9s/hotkey.yml

RUN  chmod +x /bin/ttyd && chmod +x /bin/ekz-ui

RUN apk update && apk add --no-cache tmux musl-locales

ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8
ENV COLORTERM truecolor

WORKDIR /root
ENTRYPOINT ["/bin/ttyd"]

CMD ["-p", "8080", "/bin/ekz-ui"]
