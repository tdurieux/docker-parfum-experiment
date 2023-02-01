FROM ubuntu:14.04
MAINTAINER Matthew Tardiff <mattrix@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install --no-install-recommends -y gawk && rm -rf /var/lib/apt/lists/*;
COPY src /app
RUN chmod u+x /app/2048.sh
CMD []
ENTRYPOINT ["/app/2048.sh"]
