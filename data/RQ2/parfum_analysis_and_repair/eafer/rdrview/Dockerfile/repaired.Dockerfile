FROM debian AS builder

RUN apt update && apt install --no-install-recommends build-essential libxml2-dev libseccomp-dev libcurl4-gnutls-dev -y && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN make && make install

FROM debian
RUN apt update && apt install --no-install-recommends -y libcurl3-gnutls libxml2 lynx && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /usr/local/bin/rdrview /usr/local/bin/rdrview
CMD ["/usr/local/bin/rdrview"]
