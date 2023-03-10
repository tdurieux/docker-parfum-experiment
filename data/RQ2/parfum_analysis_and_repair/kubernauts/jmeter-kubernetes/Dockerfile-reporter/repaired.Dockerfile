# build
FROM golang:1.8-stretch AS build
WORKDIR /go/src/${owner:-github.com/IzakMarais}/reporter
RUN apt-get update && apt-get install --no-install-recommends -y make git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://${owner:-github.com/IzakMarais}/reporter .
RUN make build

# create image
FROM debian:stretch
RUN PACKAGES="wget libswitch-perl texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra ca-certificates" \
    && apt-get update \
    && apt-get install -y -qq $PACKAGES --no-install-recommends \
    && wget -qO- https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz \
    && cd install-tl-* \
    && ./install-tl -profile /texlive.profile \
    # Cleanup
    && rm -rf install-tl-* \
    && apt-get remove --purge -y -qq $PACKAGES \
    && apt-get autoremove --purge -y -qq \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/tex

COPY --from=build /go/bin/grafana-reporter /usr/local/bin
ENTRYPOINT [ "/usr/local/bin/grafana-reporter","-ip","jmeter-grafana:3000" ]
