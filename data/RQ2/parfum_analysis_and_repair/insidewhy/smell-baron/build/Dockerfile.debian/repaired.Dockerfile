FROM debian
MAINTAINER Evgeny Kruglov <ekruglov@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y gcc make && rm -rf /var/lib/apt/lists/*;
ADD . /smell-baron
RUN cd smell-baron && make release
