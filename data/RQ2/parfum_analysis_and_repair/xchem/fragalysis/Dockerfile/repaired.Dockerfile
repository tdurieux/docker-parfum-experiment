FROM informaticsmatters/rdkit-python-debian:Release_2018_09_1
ADD requirements.txt requirements.txt
USER root
RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get --allow-releaseinfo-change update && \
    apt-get install --no-install-recommends -y git procps && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/rdkit/mmpdb /usr/local/mmpdb
RUN pip install --no-cache-dir /usr/local/mmpdb
ADD . /usr/local/fragalysis
RUN pip install --no-cache-dir /usr/local/fragalysis
