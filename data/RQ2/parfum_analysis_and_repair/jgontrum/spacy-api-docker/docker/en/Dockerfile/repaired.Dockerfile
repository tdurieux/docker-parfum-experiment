FROM jgontrum/spacyapi:base_v2

ENV languages "en"
RUN cd /app && env/bin/download_models