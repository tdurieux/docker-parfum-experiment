MAINTAINER Mahdi Jelodari M. <mahdi.jelodari@reconfigure.io>

RUN apt-get update && apt-get install --no-install-recommends -y golang && rm -rf /var/lib/apt/lists/*;
