FROM seldonio/pyseldon

# install kenlm
RUN apt-get -y --no-install-recommends -q install build-essential libboost-all-dev zlib1g-dev libbz2-dev liblzma-dev && rm -rf /var/lib/apt/lists/*;

RUN wget -O - https://kheafield.com/code/kenlm.tar.gz | tar xz; cd  kenlm ; ./bjam -j4

ADD ./ngram_scripts /ngram_scripts

