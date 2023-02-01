FROM ubuntu
MAINTAINER pablo@caldito.me
RUN apt update && apt install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
COPY bin/soup /bin/
RUN chmod +x /bin/soup
CMD ["/bin/soup"]
