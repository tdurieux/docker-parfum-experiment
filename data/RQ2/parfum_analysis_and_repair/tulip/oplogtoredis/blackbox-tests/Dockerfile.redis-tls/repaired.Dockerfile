from runnable/redis-stunnel
RUN echo "connect = $REDIS_PORT_6379_TCP_ADDR:$REDIS_PORT_6379_TCP_PORT" >> /stunnel/stunnel.conf