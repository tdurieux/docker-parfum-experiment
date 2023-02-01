# -------------------------------------------------------
# -------------------------------------------------------
FROM ubuntu:18.10

# use bash instead of sh
SHELL ["/bin/bash", "-c"]

#
## ...
#
RUN apt-get update --fix-missing
RUN apt-get install --no-install-recommends -yq wget && rm -rf /var/lib/apt/lists/*;

#
## direct pykafarr dependencies!!
#
RUN apt-get install --no-install-recommends -yq libjansson-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq libcurl4-gnutls-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR  /workstem
RUN      wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN      /bin/bash /workstem/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda
RUN      rm /workstem/Miniconda3-latest-Linux-x86_64.sh
ENV      PATH=/opt/miniconda/bin/:$PATH
#
## ideally, all the depencencies would be declared and installed.
#
CMD      ["conda", "install", "-y", "-c", "ikucan", "pykafarr"]
#install -y -c iztok pykafarr"
