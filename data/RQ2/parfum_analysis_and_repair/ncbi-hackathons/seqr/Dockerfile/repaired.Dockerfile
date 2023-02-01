FROM java:8-jre
MAINTAINER Justin Payne justin.payne@fda.hhs.gov

RUN apt-get UPDATE -y && apt-get install --no-install-recommends -y \
    maven \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

