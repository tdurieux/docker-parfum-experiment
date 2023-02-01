from trailofbits/polytracker
MAINTAINER Carson Harmon <carson.harmon@trailofbits.com>

WORKDIR /polytracker/the_klondike

# Install GLLVM
RUN apt update -y && apt install --no-install-recommends golang -y && rm -rf /var/lib/apt/lists/*;

RUN go get github.com/SRI-CSL/gllvm/cmd/...

ENV PATH="$PATH:/root/go/bin"

