FROM python:3.8.2

# 環境変数の設定
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV INFERNAL_NCPU 1

# Create working directory
RUN mkdir /work && chmod 777 /work

# Install dependency
RUN pip install --no-cache-dir biopython && \
    apt-get update && \
    apt install --no-install-recommends -y default-jre zip prodigal infernal && \
    ln -s /usr/bin/cmscan /usr/local/bin/cmscan && \
    ln -s /usr/bin/cmsearch /usr/local/bin/cmsearch && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
	curl -f -LO https://github.com/UCSC-LoweLab/tRNAscan-SE/archive/v2.0.6.tar.gz && \
	tar xfz v2.0.6.tar.gz && \
	cd tRNAscan-SE-2.0.6 && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && \
    cd .. && \
	rm -r /tmp/tRNAscan-SE-2.0.6 /tmp/v2.0.6.tar.gz && \
	cd /work

ENV INCREMENT_THIS_TO_BUMP 1
# Install dfast_core
RUN cd / && \
    git clone https://github.com/nigyta/dfast_core && \
    ln -s /dfast_core/dfast /usr/local/bin/ && \
    ln -s /dfast_core/scripts/dfast_file_downloader.py /usr/local/bin/ && \
    ln -s /dfast_core/scripts/reference_util.py /usr/local/bin/

# Prepare reference data (currently disabled)
# RUN dfast_file_downloader.py --protein dfast bifido cyanobase ecoli lab --cdd Cog --hmm TIGR


WORKDIR /work

CMD /bin/bash
