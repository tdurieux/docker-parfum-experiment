# Basic debian file with curl, wget and nano installed to fetch files
# an update config files
FROM debian:latest
MAINTAINER Nicolas Ruflin <ruflin@elastic.co>

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl nano wget zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;


