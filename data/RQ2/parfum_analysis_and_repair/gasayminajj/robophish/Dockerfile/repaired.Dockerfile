FROM debian:10
LABEL MAINTAINER="https://github.com/htr-tech/zphisher"

WORKDIR zphisher/
ADD . /zphisher

RUN apt-get update
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y php && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

CMD ["./zphisher.sh"]
