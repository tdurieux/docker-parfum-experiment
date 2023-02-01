FROM stimela/base:1.0.1
ADD . /Stimela
WORKDIR /Stimela
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir /Stimela
ENV USER root
RUN stimela
