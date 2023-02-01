FROM ubuntu:14.04
RUN apt-get update && apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;
ADD twitter_ethereumproof.py twitter_ethereumproof.py
MAINTAINER Adam "adam.dossa@gmail.com”
CMD python twitter_ethereumproof.py
