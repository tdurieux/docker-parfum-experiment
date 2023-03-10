# Build www
FROM node:12.14 as wwwbuild
USER root
RUN git clone https://github.com/decred/politeiagui.git \
    && cd politeiagui \
    && yarn install --network-concurrency 1 \
    && INLINE_RUNTIME_CHUNK=false yarn build:cms && yarn cache clean;

# Build gobins
FROM golang:1.15 AS gobuild

RUN git clone https://github.com/decred/politeia.git \
    && cd politeia \
    &&  go install -v ./...

# Final image
FROM ubuntu:latest
COPY --from=gobuild /go/bin /root/pibins
COPY --from=gobuild /go/politeia/scripts /root/piscripts
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y --no-install-recommends -qq wget git tzdata nginx jq && rm -rf /var/lib/apt/lists/*;
RUN mkdir $HOME/scripts/ \
    && mkdir $HOME/.politeiawww/ \
    && mkdir $HOME/.politeiad/ \
    && mkdir $HOME/.piwww/
RUN wget -qO- https://binaries.cockroachdb.com/cockroach-v20.1.6.linux-amd64.tgz | tar  xvz
RUN mv -i cockroach-v20.1.6.linux-amd64/cockroach /usr/local/bin/
COPY --from=wwwbuild /politeiagui/build /usr/share/nginx/html
COPY ./dockerfiles/politeiad.conf /root/.politeiad/politeiad.conf
COPY ./dockerfiles/politeiawww.conf /root/.politeiawww/politeiawww.conf
COPY ./dockerfiles/piwww.conf /root/.piwww/piwww.conf
COPY ./dockerfiles/setup.sh /root/scripts/setup.sh
COPY ./dockerfiles/run.sh /root/scripts/run.sh
COPY ./dockerfiles/nginx.conf /etc/nginx/conf.d/nginx.conf
COPY ./dockerfiles/headers.conf /etc/nginx/conf.d/headers.conf
COPY ./dockerfiles/nginx.cert /etc/nginx/conf.d/nginx.cert
COPY ./dockerfiles/nginx.key /etc/nginx/conf.d/nginx.key
RUN chmod +x /root/scripts/setup.sh \
    && /root/scripts/setup.sh
RUN chmod +x /root/scripts/run.sh
RUN apt-get -qq -y remove wget jq
# Change to CMS
RUN sed -i 's/piwww/cmswww/g' /root/.politeiawww/politeiawww.conf
RUN sed -i 's/piwww/cmswww/g' /root/.politeiad/politeiad.conf
# Start cmd
CMD /root/scripts/run.sh && tail -f /dev/null