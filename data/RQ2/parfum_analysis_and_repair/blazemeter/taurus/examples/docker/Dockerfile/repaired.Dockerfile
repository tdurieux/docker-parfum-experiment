FROM python

RUN pip install --no-cache-dir bzt && bzt --help

RUN echo "settings:\n  default-executor: apiritif" > /root/.bzt-rc

WORKDIR /tmp
ENTRYPOINT ["bzt"]
