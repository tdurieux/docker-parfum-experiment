# This base image has command that install build-essential(includes cc command)
FROM nacyot/ubuntu

RUN apt-get install --no-install-recommends -y gobjc && rm -rf /var/lib/apt/lists/*;

WORKDIR /source
