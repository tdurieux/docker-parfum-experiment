FROM ubuntu:20.04

# Copy files
COPY . immuneML

RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install python3.8 python3-pip git-all -y && rm -rf /var/lib/apt/lists/*;

# install the dependency CompAIRR
RUN git clone https://github.com/uio-bmi/compairr.git compairr_folder
RUN make -C compairr_folder
RUN cp ./compairr_folder/src/compairr ./compairr

# Voila: install immuneML
RUN pip3 install --no-cache-dir ./immuneML/[TCRdist]
