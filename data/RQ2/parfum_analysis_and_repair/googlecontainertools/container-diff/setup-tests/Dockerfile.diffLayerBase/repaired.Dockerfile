FROM gcr.io/gcp-runtimes/ubuntu_16_0_4:latest

# docker build . -f Dockerfile.diffLayerBase -t gcr.io/gcp-runtimes/container-diff-tests/diff-layer-base:latest


RUN mkdir /first && echo "First" > /first/first.txt
RUN mkdir /second && echo "Second" > /second/second.txt
RUN mkdir /third && echo "Third" > /third/third.txt