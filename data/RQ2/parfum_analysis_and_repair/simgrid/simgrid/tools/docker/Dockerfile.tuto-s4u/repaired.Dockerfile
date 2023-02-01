# Base image
FROM simgrid/stable

RUN apt update && apt -y upgrade

# - Clone simgrid-template-s4u, as it is needed by the tutorial
# - Add an empty makefile advising to run cmake before make, just in case
RUN apt install --no-install-recommends -y python-is-python3 pajeng r-base r-cran-tidyverse r-cran-devtools cmake g++ git libboost-dev libeigen3-dev flex bison libfmt-dev && \
    cd /source && \
    git clone --depth=1 https://framagit.org/simgrid/simgrid-template-s4u.git simgrid-template-s4u.git && \
    printf "master-workers ping-pong:\n\t@echo \"Please run the following command before make:\";echo \"    cmake .\"; exit 1" > Makefile && \
    apt autoremove -y && apt clean && apt autoclean && rm -rf /var/lib/apt/lists/*;

RUN Rscript -e "library(devtools); install_github('schnorr/pajengr');"

CMD ["/bin/bash"]
