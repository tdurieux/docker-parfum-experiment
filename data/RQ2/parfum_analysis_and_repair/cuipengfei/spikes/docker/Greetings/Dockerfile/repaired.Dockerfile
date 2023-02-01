# This is a comment
FROM ubuntu:14.04
MAINTAINER Cui Pengfei
RUN apt-get update && apt-get install --no-install-recommends -y tree && rm -rf /var/lib/apt/lists/*;
CMD echo "tree and git, only text2"
