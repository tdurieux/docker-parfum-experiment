# Base image 
FROM simgrid/stable

RUN apt update && apt -y upgrade 

RUN apt install -y sudo && \
    groupadd -g 999 user && \
    useradd -r -u 999 -g user user && \
    echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user && \
    mkdir -p /home/user && \
    chown -R user:user /home/user

# - Clone simgrid-template-s4u, as it is needed by the tutorial
# - Add an empty makefile advising to run cmake before make, just in case
RUN apt install -y pajeng r-base r-cran-ggplot2 r-cran-dplyr r-cran-devtools cmake g++ git libboost-all-dev flex bison&& \
    cd /source && \
    git clone --depth=1 https://framagit.org/simgrid/simgrid-template-s4u.git simgrid-template-s4u.git && \
    printf "master-workers ping-pong:\n\t@echo \"Please run the following command before make:\";echo \"    cmake .\"; exit 1" > Makefile &&\
    chown -R user:user /source && \
    apt autoremove -y && apt clean && apt autoclean && \
    chown -R user:user /source

RUN Rscript -e "library(devtools); install_github('schnorr/pajengr');"

CMD ["su", "-", "user", "-c", "/bin/bash"]
