FROM golang:1.9-stretch
RUN apt-get update
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libgtk-3-dev libcairo2-dev libglib2.0-dev && rm -rf /var/lib/apt/lists/*;

RUN dpkg -l libgtk-3-0

CMD ["go", "get", "-v", "-tags","gtk_3_22 gui", "github.com/nogoegst/onionize/cmd/onionize"]
