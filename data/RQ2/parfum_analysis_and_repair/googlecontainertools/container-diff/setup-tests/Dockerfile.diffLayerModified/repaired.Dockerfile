FROM gcr.io/gcp-runtimes/ubuntu_16_0_4:latest

# docker build . -f Dockerfile.diffLayerModified -t gcr.io/gcp-runtimes/container-diff-tests/diff-layer-modified:latest

RUN mkdir /first && echo "First" > /first/first.txt
RUN echo "No Second Layer"
RUN mkdir /modified && echo "Modified" > /modified/modified.txt