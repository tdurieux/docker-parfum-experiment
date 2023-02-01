FROM debian:stable

# this is tagged as deltachat/doxygen

RUN apt-get update && apt-get install --no-install-recommends -y doxygen && rm -rf /var/lib/apt/lists/*;
