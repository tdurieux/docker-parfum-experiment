FROM %%ALPINE_IMG%%/alpine:%%ALPINE_TAG%%
MAINTAINER Richard Mortier <mort@cantab.net>

RUN rm /etc/apk/repositories && \
    printf -- >> /etc/apk/repositories \
      'http://dl-cdn.alpinelinux.org/alpine/%%ALPINE_REL%%/%s\n' \
      main community $(test edge = "%%ALPINE_TAG%%" && echo testing) && \
    printf -- >> /etc/apk/repositories \
      '/home/builder/packages/%s\n' \
      main community testing

RUN apk add --no-cache --update-cache \
      alpine-conf \
      alpine-sdk \
      sudo \
      ccache \
    && apk upgrade -a \
    && setup-apkcache /var/cache/apk

RUN adduser -D builder \
    && addgroup builder abuild \
    && echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER builder
WORKDIR /home/builder
COPY entrypoint.sh /home/builder
RUN mkdir packages

ENTRYPOINT ["/home/builder/entrypoint.sh"]
