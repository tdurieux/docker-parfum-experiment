FROM python:3.6.8-stretch
RUN pip3 install --no-cache-dir fiber
ADD . /work/
RUN cd /work && pip3 install --no-cache-dir -e .[test]
RUN cd /work && pip3 install --no-cache-dir -e .
