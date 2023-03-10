FROM busybox as base
RUN mkdir -p /a && touch /a/1
RUN ln -s /a /b
FROM busybox
COPY --from=base /b/1 /a/b/c
RUN ls -al /a/b/c && ! ls -al /a/b/1