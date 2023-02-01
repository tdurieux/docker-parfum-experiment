FROM gcr.io/gcp-runtimes/centos7:latest

# docker build . -f Dockerfile.diffBase -t gcr.io/gcp-runtimes/container-diff-tests/diff-base:latest

RUN yum -q -y install which && rm -rf /var/cache/yum
RUN mkdir /first && echo "First" > /first/first.txt
RUN mkdir /second && echo "Second" > /second/second.txt
RUN mkdir /third && echo "Third" > /third/third.txt
