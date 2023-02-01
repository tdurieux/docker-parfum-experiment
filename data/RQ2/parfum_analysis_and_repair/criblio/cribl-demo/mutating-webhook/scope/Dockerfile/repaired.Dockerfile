FROM alpine
ADD copyscope.sh /sbin/copyscope.sh
RUN apk add --no-cache curl && \
    mkdir -p /orig && \
    curl -f -Lso /orig/libscope.so https://cdn.cribl.io/dl/scope/latest/linux/libscope.so && \
    curl -f -Lso /orig/scope https://cdn.cribl.io/dl/scope/latest/linux/scope && \
    apk del --no-cache curl
RUN chmod 755 /orig/*
ADD scope-logstream.yml /orig/scope.yml
CMD /sbin/copyscope.sh
