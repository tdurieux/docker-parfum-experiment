FROM ubuntu:trusty

RUN sudo apt-get -qq update \
 && sudo apt-get install --no-install-recommends -y wget git python-pygments doxygen && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/spf13/hugo/releases/download/v0.17/hugo_0.17-64bit.deb \
 && sudo dpkg -i hugo_0.17-64bit.deb

RUN mkdir /work

COPY data/build.sh /work
RUN chmod +x /work/build.sh

WORKDIR /work
CMD ./build.sh
