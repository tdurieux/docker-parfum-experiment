FROM jupyter/notebook

MAINTAINER Doug Blank <doug.blank@gmail.com>

RUN pip3 install --no-cache-dir --upgrade metakernel
RUN pip3 install --no-cache-dir --upgrade calysto-scheme
