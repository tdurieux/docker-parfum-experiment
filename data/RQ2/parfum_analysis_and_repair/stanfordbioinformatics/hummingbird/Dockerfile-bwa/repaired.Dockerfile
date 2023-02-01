FROM broadinstitute/gatk:4.1.4.0

LABEL bwa.version="0.7.17"
LABEL gatk.version="4.1.3.0"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    curl \
    time && rm -rf /var/lib/apt/lists/*;

RUN conda install -c bioconda -y bwa==0.7.17

RUN curl -f -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
  unzip awscliv2.zip && \
  ./aws/install

RUN git clone https://github.com/lh3/seqtk.git && cd seqtk && make install

COPY scripts/ /usr/local/bin/
WORKDIR /tmp

ENTRYPOINT ["/usr/local/bin/fetch_and_run.sh"]
