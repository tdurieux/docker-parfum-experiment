FROM ubuntu as bd2
RUN apt-get -y update && apt-get -y --no-install-recommends install git && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_*
RUN apt-get -y update && apt-get -y --no-install-recommends install build-essential libssl-dev git zlib1g-dev software-properties-common luarocks; rm -rf /var/lib/apt/lists/*; luarocks install penlight
RUN git config --global user.email "meshery@layer5.io"
RUN git config --global user.name "meshery"
RUN git clone --depth=1 https://github.com/layer5io/wrk2 && cd wrk2 && make && mv wrk /usr/local/bin
RUN add-apt-repository ppa:longsleep/golang-backports; apt-get update; apt-get install --no-install-recommends -y golang-go && rm -rf /var/lib/apt/lists/*;