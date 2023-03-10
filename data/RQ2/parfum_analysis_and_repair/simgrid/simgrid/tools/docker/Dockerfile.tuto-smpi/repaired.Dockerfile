# Base image
FROM simgrid/stable

# https://stackoverflow.com/questions/35134713/disable-cache-for-specific-run-commands
ADD "http://deb.debian.org/debian/dists/testing/Release" skipcache
RUN apt update && apt -y upgrade

# - Clone simgrid-template-smpi, as it is needed by the tutorial
RUN apt install --no-install-recommends -y python3 pajeng libssl-dev r-base r-cran-devtools r-cran-tidyverse build-essential g++ gfortran git libboost-dev libeigen3-dev cmake flex bison libfmt-dev && \
    cd /source && \
    git clone --depth=1 https://framagit.org/simgrid/simgrid-template-smpi.git simgrid-template-smpi.git && \
    apt autoremove -y && apt clean && apt autoclean && rm -rf /var/lib/apt/lists/*;

RUN Rscript -e "library(devtools); install_github('schnorr/pajengr');"

CMD ["/bin/bash"]
