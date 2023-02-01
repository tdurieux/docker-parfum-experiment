FROM python

MAINTAINER Giuseppe Romano <romanog@mit.edu>

RUN apt-get update && apt-get install --no-install-recommends -y build-essential libopenmpi-dev libgmsh-dev && rm -rf /var/lib/apt/lists/*;

ADD dist app

WORKDIR app

RUN pip install --no-cache-dir --no-cache openbte-2.71.0.tar.gz

RUN useradd -ms /bin/bash openbte

ENV OMPI_MCA_btl_vader_single_copy_mechanism none

ENV OMPI_MCA_btl_base_warn_component_unused 0

ENV MPLCONFIGDIR /tmp/matplotlib

RUN mkdir /workspace

USER openbte

WORKDIR /home/openbte

LABEL org.opencontainers.image.source https://github.com/romanodev/openbte

EXPOSE 8050







