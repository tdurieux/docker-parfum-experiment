FROM calavera/go-glide:v0.12.2

ADD . /go/src/github.com/netlify/gotell

RUN useradd -m netlify && cd /go/src/github.com/netlify/gotell && make deps build && mv gotell /usr/local/bin/

USER netlify
CMD ["gotell"]
