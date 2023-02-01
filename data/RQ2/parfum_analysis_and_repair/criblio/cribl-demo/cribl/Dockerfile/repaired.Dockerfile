#ADD http://cdn.cribl.io/dl/scope/latest/linux/libscope.so /usr/lib/libscope.so
#RUN chmod 755 /usr/lib/libscope.so
#ENV LD_PRELOAD=/usr/lib/libscope.so