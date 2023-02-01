FROM clintsharp/gogen:latest
ADD gogen /etc/gogen
ENV GOGEN_CONFIG_DIR /etc/gogen
ENV GOGEN_ADDTIME true
ENV GOGEN_LOGJSON true
ENV GOGEN_INFO true


# ADD http://cdn.cribl.io/dl/scope/latest/linux/libscope.so /usr/lib/libscope.so
# ADD http://cdn.cribl.io/dl/scope/latest/linux/scope /usr/bin/scope
# RUN chmod 755 /usr/lib/libscope.so /usr/bin/scope
# # ENV LD_PRELOAD=/usr/lib/libscope.so
# ENV SCOPE_METRIC_DEST=tcp://cribl-w1:8125
# ENV SCOPE_LOG_LEVEL=info
# ENV SCOPE_LOG_DEST=file:///tmp/scope.log
# ENV SCOPE_METRIC_VERBOSITY=5
# ENV SCOPE_EVENT_DEST=tcp://cribl-w0:10001
# ENV SCOPE_EVENT_HTTP=true
# ENV SCOPE_TAG_service=gogen
# CMD [ "/usr/bin/scope", "/usr/bin/gogen", "gen"]