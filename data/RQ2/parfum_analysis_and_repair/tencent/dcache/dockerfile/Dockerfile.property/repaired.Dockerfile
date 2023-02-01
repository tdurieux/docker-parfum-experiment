FROM tarscloud/dcache-compiler as First

FROM tarscloud/tars.cppbase

ENV ServerType=cpp

RUN mkdir -p /usr/local/server/bin/
COPY --from=First /data/build/bin/PropertyServer /usr/local/server/bin/