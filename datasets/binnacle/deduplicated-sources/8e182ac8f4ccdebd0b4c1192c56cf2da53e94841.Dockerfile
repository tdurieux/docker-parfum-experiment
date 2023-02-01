FROM alpine:3.5
MAINTAINER dwhitena

# Add gophernotes
ADD . /go/src/github.com/gopherdata/gophernotes/

# Install Jupyter and gophernotes.
RUN set -x \
    # install python and dependencies
    && apk update \
    && apk --no-cache \
        --repository http://dl-4.alpinelinux.org/alpine/v3.7/community \
        --repository http://dl-4.alpinelinux.org/alpine/v3.7/main \
        --arch=x86_64 add \
        python3 \
        su-exec \
        gcc \
        g++ \
        git \
        py3-zmq \
        pkgconfig \ 
        zeromq-dev \
        musl-dev \
        mercurial \
    && pip3 install --upgrade pip==9.0.3 \
    && cp /usr/bin/python3.6 /usr/bin/python \
    ## install Go
    && apk --update-cache --allow-untrusted \
        --repository http://dl-4.alpinelinux.org/alpine/edge/community \
        --arch=x86_64 add \
        go \
    ## jupyter notebook 
    && ln -s /usr/include/locale.h /usr/include/xlocale.h \
    ### fix pyzmq to v16.0.2 as that is what is distributed with py3-zmq
    ### pin down the tornado and ipykernel to compatible versions
    && pip3 install jupyter notebook pyzmq==16.0.2 tornado==4.5.3 ipykernel==4.8.1 \
    ## install gophernotes
    && export GOPATH=/go \
    && go install github.com/gopherdata/gophernotes \
    && cp /go/bin/gophernotes /usr/local/bin/ \
    && mkdir -p ~/.local/share/jupyter/kernels/gophernotes \
    && cp -r /go/src/github.com/gopherdata/gophernotes/kernel/* ~/.local/share/jupyter/kernels/gophernotes \
    ## get the relevant Go packages
    && go get -insecure gonum.org/v1/plot/... \
    && go get -insecure gonum.org/v1/gonum/... \
    && go get github.com/kniren/gota/... \
    && go get github.com/sajari/regression \
    && go get github.com/sjwhitworth/golearn/... \
    && go get -insecure go-hep.org/x/hep/csvutil/... \
    && go get -insecure go-hep.org/x/hep/fit \
    && go get -insecure go-hep.org/x/hep/hbook \
    && go get github.com/montanaflynn/stats \
    && go get github.com/boltdb/bolt \
    && go get github.com/patrickmn/go-cache \
    && go get github.com/chewxy/math32 \
    && go get github.com/chewxy/hm \
    && go get gorgonia.org/vecf64 \
    && go get gorgonia.org/vecf32 \
    && go get github.com/awalterschulze/gographviz \
    && go get github.com/leesper/go_rng \
    && go get github.com/pkg/errors \
    && go get github.com/stretchr/testify/assert \
    ## clean
    && find /usr/lib/python3.6 -name __pycache__ | xargs rm -r \
    && rm -rf \
        /root/.[acpw]* \
        ipaexg00301* \
    && rm -rf /var/cache/apk/*

# Set GOPATH.
ENV GOPATH /go

EXPOSE 8888
CMD [ "jupyter", "notebook", "--no-browser", "--allow-root", "--ip=0.0.0.0" ]
