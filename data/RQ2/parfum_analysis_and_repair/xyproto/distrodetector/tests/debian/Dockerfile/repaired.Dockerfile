FROM debian
ENV PROJECT distrodetector
ENV GOVER 1.11.2
ENV PACKAGES curl gcc git
ENV PATH /go/bin:$PATH
RUN apt-get update && apt-get -y upgrade && apt-get -y --no-install-recommends install $PACKAGES && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sOL "https://dl.google.com/go/go$GOVER.linux-amd64.tar.gz"
RUN tar x -C / -f "go$GOVER.linux-amd64.tar.gz" && rm "go$GOVER.linux-amd64.tar.gz"
RUN git clone "https://github.com/xyproto/$PROJECT" "/$PROJECT"
WORKDIR "/$PROJECT"
CMD go test
