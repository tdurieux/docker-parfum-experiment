FROM sensu/sensu-ruby-runtime-2.4.4-alpine:latest as builder
ARG ASSET_GEM
ARG GIT_REF
ARG GIT_REPO
WORKDIR /assets/build/
RUN apk add --no-cache git libcurl curl

RUN \
  gem install --no-ri --no-doc bundler && \
  printf "source 'https://rubygems.org'\n\ngem \"%s\", :git => \"%s\" , :ref => \"%s\"\n" ${ASSET_GEM} ${GIT_REPO} ${GIT_REF}| tee Gemfile

RUN bundle install --path=lib/ --binstubs=bin/ --standalone

RUN LIBS=$(find /usr/lib/libcurl* -type f -exec ldd {} 2>/dev/null \;|  grep "=>" | grep -v "vdso.so.1" | grep -v "ldd" | awk '{print $3}'| sort -u ) && \
  for f in $LIBS; do if [ -e $f ]; then echo "Copying Library: $f" && cp $f /assets/build/lib/; fi; done

RUN cp /usr/bin/curl /assets/build/bin/
RUN LIBS=$(ldd /assets/build/bin/curl 2>/dev/null \;|  grep "=>" | grep -v "vdso.so.1" | grep -v "ldd" | awk '{print $3}'| sort -u ) && \
  for f in $LIBS; do if [ -e $f ]; then echo "Copying Library: $f" && cp $f /assets/build/lib/; fi; done

RUN tar -czf /assets/${ASSET_GEM}.tar.gz -C /assets/build/ . && rm /assets/${ASSET_GEM}.tar.gz

FROM scratch
ARG ASSET_GEM
COPY --from=builder /assets/${ASSET_GEM}.tar.gz /
