FROM stimela/base:1.2.5
RUN pip3 install --no-cache-dir -U pip pyyaml
RUN pip3 install --no-cache-dir eidos >=1.1.0
RUN eidos -h
