FROM sysstacks/dlrs-serving-ubuntu:v0.9.0

RUN pip install --no-cache-dir jaeger-client==3.13.0 seldon-core tornado>=5.0\
    && pip install --no-cache-dir --upgrade setuptools \
    && sed -i "s/max_workers=10/max_workers=1/g" /usr/lib/python3.7/site-packages/seldon_core/wrapper.py

RUN git clone https://github.com/SeldonIO/seldon-core.git /opt/seldon-core \
    && mkdir -p /s2i/bin \
    && cp -a /opt/seldon-core/wrappers/s2i/python/s2i/bin/ /s2i/bin/
    
WORKDIR /microservice

EXPOSE 5000