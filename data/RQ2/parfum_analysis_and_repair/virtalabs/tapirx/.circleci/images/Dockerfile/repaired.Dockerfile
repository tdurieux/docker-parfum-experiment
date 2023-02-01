FROM circleci/golang:1.11

RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y libpcap-dev && rm -rf /var/lib/apt/lists/*;
