ARG BASE_CONTAINER=ubuntu:20.04
FROM ${BASE_CONTAINER}
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -qy --no-install-recommends \
		build-essential cmake make wget libpython3-dev python3-pip libreadline-dev llvm-10-dev git \
        apt-utils \
        ffmpeg \
        sox \
        libcairo2-dev \
        texlive \
        texlive-fonts-extra \
        texlive-latex-extra \
        texlive-latex-recommended \
        texlive-science \
		texlive-extra-utils \
	    tipa \
		dvisvgm \
    && rm -rf /var/lib/apt/lists/*

ARG SS_RELEASE=v4.0.1
ARG SS_BURBLE=0
ARG SS_COMPACT=0

WORKDIR /build
RUN wget --quiet https://github.com/DrTimothyAldenDavis/GraphBLAS/archive/v$SS_RELEASE.tar.gz
RUN tar -xf v$SS_RELEASE.tar.gz && rm v$SS_RELEASE.tar.gz

WORKDIR /build/GraphBLAS-$SS_RELEASE/build
RUN cmake .. -DGB_BURBLE=${SS_BURBLE} -DGBCOMPACT=${SS_COMPACT} && make -j8 && make install
RUN ldconfig

RUN git clone https://github.com/3b1b/manim.git /manim

WORKDIR /manim
RUN python3 setup.py sdist \
    && python3 -m pip install dist/manimlib*

RUN /bin/rm -Rf /build

ADD . /pygraphblas
WORKDIR /pygraphblas

RUN pip3 install --no-cache-dir -r minimal-requirements.txt
RUN python3 setup.py install
RUN ldconfig
RUN pytest
