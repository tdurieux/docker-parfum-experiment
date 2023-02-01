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

# - Clone simgrid-template-smpi, as it is needed by the tutorial
RUN apt install -y pajeng libssl-dev r-base r-cran-ggplot2 r-cran-dplyr r-cran-devtools build-essential g++ gfortran git libboost-all-dev cmake flex bison && \
    cd /source && \
    git clone --depth=1 https://framagit.org/simgrid/simgrid-template-smpi.git simgrid-template-smpi.git && \
    chown -R user:user /source && \
    apt autoremove -y && apt clean && apt autoclean
    
RUN Rscript -e "library(devtools); install_github('schnorr/pajengr');"

CMD ["su", "-", "user", "-c", "/bin/bash"]
