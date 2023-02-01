FROM python:3.7
ENV DEBIAN_FRONTEND noninteractive

RUN pip install --no-cache-dir numpy==1.16.4
RUN pip install --no-cache-dir pandas==0.24.2
RUN pip install --no-cache-dir biopython
RUN pip install --no-cache-dir argparse
RUN pip install --no-cache-dir networkx==2.3
COPY swigg.py /usr/bin/
RUN chmod a+x /usr/bin/*

CMD ["swigg.py"]
