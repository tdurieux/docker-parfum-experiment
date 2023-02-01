FROM continuumio/miniconda3
WORKDIR /code

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget curl gawk build-essential && rm -rf /var/lib/apt/lists/*;

RUN conda install -y numpy scipy pandas cython \
    && pip install --no-cache-dir rankit

RUN curl -f -sL https://aka.ms/InstallAzureCLIDeb | bash

ADD customrank.py customtags.py generate_matrix.py work.sh /code/

ENTRYPOINT ["bash", "work.sh"]