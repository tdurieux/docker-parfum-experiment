FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y libgmp3-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /opt/app
WORKDIR /opt/app
COPY .stack-work/docker/_home/.local/bin .
COPY models ./models
CMD ["/opt/app/battlescribe-roster-parser"]

