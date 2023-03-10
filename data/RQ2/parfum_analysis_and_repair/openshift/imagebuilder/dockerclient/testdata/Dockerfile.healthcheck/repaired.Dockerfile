FROM debian
CMD /app/main.sh
HEALTHCHECK   CMD   a b
HEALTHCHECK --timeout=3s CMD ["foo"]
HEALTHCHECK --start-period=8s --interval=5s --timeout=3s --retries=3 \
  CMD /app/check.sh --quiet