FROM debian:bullseye
RUN apt-get update
RUN apt-get install --no-install-recommends -y emacs-nox vim jed unzip zip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget git make cmake gcc g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y liblua5.3-dev && rm -rf /var/lib/apt/lists/*;

RUN useradd -ms /bin/bash faupuser
USER faupuser
WORKDIR /home/faupuser/
RUN git clone https://github.com/stricaud/tutoprompt/
RUN mkdir /home/faupuser/.tutoprompt/
RUN cp tutoprompt/examples/faupworkshop/* /home/faupuser/.tutoprompt/
RUN echo ". ./tutoprompt/tutoprompt.sh" >> /home/faupuser/.bashrc

RUN git clone https://github.com/stricaud/faup
WORKDIR /home/faupuser/faup/build
RUN cmake ..
RUN make

USER root
WORKDIR /home/faupuser/faup/build
RUN make install
RUN ldconfig
RUN mkdir /opt/faup/
RUN mv /usr/local/bin/faup /opt/faup/
COPY faup-wrapper /usr/local/bin/faup

USER faupuser
WORKDIR /home/faupuser/
RUN wget https://s3.amazonaws.com/alexa-static/top-1m.csv.zip
