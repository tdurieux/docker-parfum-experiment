FROM golang:1.10

RUN apt-get update && apt-get install --no-install-recommends -y unzip patch && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/local/go/bin/go /usr/local/bin/go
