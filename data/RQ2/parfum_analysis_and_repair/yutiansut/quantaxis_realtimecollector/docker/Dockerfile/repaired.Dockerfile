FROM daocloud.io/quantaxis/qactpbee:latest

RUN cd /root \
    && pip install --no-cache-dir simplejson \
    && pip install --no-cache-dir https://github.com/yutiansut/tornado_http2/archive/master.zip \
    && pip install --no-cache-dir tornado==5.1.1 \
    && pip install --no-cache-dir quantaxis-servicedetect \
    && git clone https://github.com/yutiansut/QUANTAXIS_RealtimeCollector \
    && cd /root/QUANTAXIS_RealtimeCollector && pip install --no-cache-dir -e . \
    && chmod +x /root/QUANTAXIS_RealtimeCollector/docker/start_collector.sh \
    && chmod +x /root/QUANTAXIS_RealtimeCollector/docker/wait_for_it.sh



EXPOSE 8011
CMD ["bash", "/root/QUANTAXIS_RealtimeCollector/docker/start_collector.sh"]
