FROM	karalabe/xgo-latest
MAINTAINER codeskyblue@gmail.com

RUN apt-get update
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y bzr && rm -rf /var/lib/apt/lists/*;

# necessary packages
RUN apt-get install --no-install-recommends -y libreadline6 && rm -rf /var/lib/apt/lists/*;

ADD requirements.txt /
RUN pip install --no-cache-dir -r requirements.txt

# add packer
RUN GOBIN=/usr/local/bin go get github.com/gpmgo/gopm
RUN GOBIN=/usr/local/bin go get github.com/tools/godep
RUN GOBIN=/build go get github.com/gobuild/gobuild3/packer

ADD crosscompile.py /build/
RUN mkdir -p gopath output

ADD run.sh /
RUN chmod +x run.sh

ENV GOPATH /gopath
ENV TIMEOUT 30m

ENTRYPOINT ["./run.sh"]
CMD ["bash"]
