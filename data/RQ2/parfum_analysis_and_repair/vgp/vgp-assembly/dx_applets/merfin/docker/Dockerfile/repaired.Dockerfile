FROM rocker/r-ver:3.6.1

LABEL com.dnanexus.tool="merfin"


RUN apt update \
  && apt -y --no-install-recommends install \
    gcc make libc-dev \
    zlib1g-dev libbz2-dev liblzma-dev libncurses-dev bzip2 \
  && apt-get install -y --no-install-recommends nano \
  && apt-get -y upgrade \
  && apt-get install --no-install-recommends -y tabix \
	&& apt-get install --no-install-recommends -y python3-pip python3-dev build-essential wget bzip2 libz-dev \
	&& ln -s /usr/bin/python3 /usr/bin/python && rm -rf /var/lib/apt/lists/*;

RUN apt update && apt upgrade && apt install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y git && git clone https://github.com/arangrhie/merfin.git && cd merfin/src && make -j 12 && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2 && tar -vxjf htslib-1.9.tar.bz2 && cd htslib-1.9 && make && rm htslib-1.9.tar.bz2

RUN wget https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2 && tar -vxjf bcftools-1.9.tar.bz2 && cd bcftools-1.9 && make && rm bcftools-1.9.tar.bz2

ENV PATH="/bcftools-1.9/:${PATH}"

ENTRYPOINT ["/bin/bash", "-c"]
