FROM      ufaldsg/pykaldi
MAINTAINER Ondrej Platek <ondrej.platek@gmail.com>

WORKDIR /app/pykaldi
# install kaldi binaries and test it
RUN apt-get update && apt-get install --no-install-recommends -y subversion cmake zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN make install-kaldi-binaries && apply-cmvn --help 2> /dev/null && echo 'Kaldi binaries installed succesfully!'
RUN make install-irstlm && echo 'IRSTLM LM modelling toolkit installed successfully!'
