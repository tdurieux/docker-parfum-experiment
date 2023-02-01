FROM adoptopenjdk/openjdk12

LABEL Name=metator Version=1.1.5

WORKDIR /app
COPY ./ /app

# Install 3rd party packages
RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends git make g++ curl && rm -rf /var/lib/apt/lists/*;

# Install miniconda to /miniconda
RUN curl -f -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda
RUN conda config --add channels bioconda

# # Get 3rd party package
RUN conda install -c conda-forge -y python=3.8\
    pip \
    bowtie2 \
    samtools \
    pairix \
    checkm-genome && conda clean -afy

# Install bwa
RUN git clone https://github.com/lh3/bwa.git && \
    cd bwa && \
    make &&\
    cd /app
ENV PATH="$PATH:/app/bwa"

# Install Louvain
RUN cd /app/external && \
    tar -xzf louvain-generic.tar.gz && \
    cd gen-louvain && \
    make && \
    cd /app && rm louvain-generic.tar.gz
ENV LOUVAIN_PATH=/app/external/gen-louvain

# Install Leiden through Network analysis repo
RUN git clone https://github.com/vtraag/networkanalysis.git && \
    cd /app/networkanalysis && \
    ./gradlew build && \
    cd /app
ENV LEIDEN_PATH=/app/networkanalysis/build/libs/networkanalysis-1.2.0.jar


# Install python dependencies
RUN pip3 install --no-cache-dir -Ur requirements.txt

# Install metator
RUN pip3 install --no-cache-dir .

ENTRYPOINT ["metator"]
