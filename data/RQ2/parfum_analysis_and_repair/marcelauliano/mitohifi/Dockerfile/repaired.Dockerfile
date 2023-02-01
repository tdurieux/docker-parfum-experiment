# Base Image
FROM ubuntu:18.04

# Metadata
LABEL base_image="ubuntu:18.04"
LABEL version="2.2"
LABEL software="MitoHiFi"
LABEL software.version="2.2"
LABEL about.summary="a python workflow that assembles a species mitogenome from Pacbio HiFi reads."
LABEL about.home="https://github.com/marcelauliano/MitoHiFi"
LABEL about.documentation="https://github.com/marcelauliano/MitoHiFi"
LABEL about.license="MIT"
LABEL about.license_file="https://github.com/marcelauliano/MitoHiFi/blob/master/LICENSE"
LABEL about.tag="mitogenome, MT, organelle"

# Maintainer
MAINTAINER Ksenia Krasheninnikova kk16@sanger.ac.uk


ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq -y update \
    && apt-get -qq --no-install-recommends -y install ncbi-blast+ \
    && umask 022 \
    && apt-get install --no-install-recommends -y python3-pip python3-dev \
    && cd /usr/local/bin \
    && ln -s /usr/bin/python3 python \
    && pip3 --no-cache-dir install --upgrade pip \
    && pip3 install --no-cache-dir biopython \
    && pip3 install --no-cache-dir pandas \
    && pip3 install --no-cache-dir entrezpy \
    && apt-get -qq --no-install-recommends -y install automake autoconf \
    && apt -qq --no-install-recommends -y install default-jre \
    && apt-get -qq --no-install-recommends -y install build-essential \
    && apt-get -qq --no-install-recommends -y install cd-hit \
    && apt-get -qq --no-install-recommends -y install mafft \
    && apt-get -qq --no-install-recommends -y install samtools \
    && apt-get -qq --no-install-recommends -y install curl \
    && curl -f -L https://github.com/lh3/minimap2/releases/download/v2.17/minimap2-2.17_x64-linux.tar.bz2 | tar -jxvf - \
    && mv ./minimap2-2.17_x64-linux/minimap2 /bin/ \
    && cd /bin/ \
    && apt-get -qq --no-install-recommends -y install git \
    && git clone https://github.com/RemiAllio/MitoFinder.git \
    && cd MitoFinder \
    && ./install.sh \
    && cd /bin/ \
    && apt-get -qq --no-install-recommends -y install wget \
    && apt-get -qq --no-install-recommends -y install libz-dev \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://github.com/chhylp123/hifiasm/archive/refs/tags/0.16.1.tar.gz \
    && tar -xzvf 0.16.1.tar.gz \
    && cd hifiasm-0.16.1 && make && rm 0.16.1.tar.gz

ENV PATH /bin/MitoFinder/:${PATH}
ENV PATH /bin/hifiasm-0.16.1/:${PATH}

COPY mitohifi.py /bin/
RUN echo "#!/usr/bin/env python" | cat - /bin/mitohifi.py | tee /bin/mitohifi.py
COPY gfa2fa /bin/
COPY alignContigs.py /bin/
COPY circularizationCheck.py /bin/
COPY cleanUpCWD.py /bin/
COPY filterfasta.py /bin/
COPY getMitoLength.py /bin/
COPY getReprContig.py /bin/
COPY parse_blast.py /bin/
COPY rotation.py /bin/
COPY fetch.py /bin/
COPY findMitoReference.py /bin/
COPY findFrameShifts.py /bin/
COPY parallel_annotation.py /bin/
RUN echo "#!/usr/bin/env python" | cat - /bin/findFrameShifts.py | tee /bin/findFrameShifts.py
COPY fixContigHeaders.py /bin/
RUN echo "#!/usr/bin/env python" | cat - /bin/fixContigHeaders.py | tee /bin/fixContigHeaders.py

RUN chmod -R 755 /bin
CMD ["/bin/bash"]
