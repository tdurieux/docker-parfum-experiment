# We use this image instead of other like Alpine due to bugs with the renderization
FROM ubuntu:14.04

RUN mkdir -p /nomi_plots

RUN apt-get update && apt-get install --no-install-recommends -y gnuplot && rm -rf /var/lib/apt/lists/*;

# Nomi
COPY ./nomi /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/nomi"]
