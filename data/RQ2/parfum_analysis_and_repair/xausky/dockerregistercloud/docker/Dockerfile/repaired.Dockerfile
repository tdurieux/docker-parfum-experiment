FROM debian:stable
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
COPY drcd /
COPY entrypoint.sh /
COPY web /build/web
RUN chmod +x /entrypoint.sh
RUN chmod +x /drcd
EXPOSE 3000
ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]
