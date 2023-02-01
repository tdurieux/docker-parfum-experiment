FROM alexellis2/python2-armhf:2

USER root

RUN pip install --no-cache-dir flask && \
    pip install --no-cache-dir requests
CMD ["python"]
