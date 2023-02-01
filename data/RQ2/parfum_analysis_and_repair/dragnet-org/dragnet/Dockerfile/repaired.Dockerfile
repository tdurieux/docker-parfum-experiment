FROM ubuntu:20.04

RUN useradd -ms /bin/bash dragnet

ENV HOME=/home/dragnet
ENV PATH="$HOME/py/bin:$HOME/miniconda3/bin:$PATH"

WORKDIR $HOME
COPY . $HOME

RUN ./provision.sh

USER dragnet

RUN pip install --no-cache-dir -r requirements.txt
RUN make install
