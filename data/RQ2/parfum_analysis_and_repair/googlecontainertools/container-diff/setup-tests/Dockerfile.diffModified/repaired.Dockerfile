FROM gcr.io/gcp-runtimes/container-diff-tests/diff-base:latest

# docker build . -f Dockerfile.diffModified -t gcr.io/gcp-runtimes/container-diff-tests/diff-modified:latest

RUN rm -rf /second && mkdir /modified && echo "Modified" > /modified/modified.txt
RUN yum -q -y install gcc && rm -rf /var/cache/yum
