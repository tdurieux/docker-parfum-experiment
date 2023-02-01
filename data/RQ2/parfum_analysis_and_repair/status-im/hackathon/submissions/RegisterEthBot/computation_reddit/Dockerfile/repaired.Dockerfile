FROM ubuntu:14.04
RUN apt-get update && apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;
ADD reddit_ethereumproof.py reddit_ethereumproof.py
MAINTAINER Adam "adam.dossa@gmail.com”
CMD python reddit_ethereumproof.py
