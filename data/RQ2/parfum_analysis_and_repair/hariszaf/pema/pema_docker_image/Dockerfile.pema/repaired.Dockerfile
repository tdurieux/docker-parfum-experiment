# PEMA: a flexible Pipeline for Environmental DNA Metabarcoding Analysis 
# of the 16S/18S ribosomal RNA, ITS, and COI marker genes. GigaScience. 2020 Mar;9(3):giaa022.
# 
# Aim:   Build PEMA Docker image based on the `pemabase` one 
# 
# Usage: docker build -t hariszaf/pemabase:<tag> .


FROM hariszaf/pemabase:v.2.1.1
LABEL maintainer = "Haris Zafeiropoulos" 
LABEL contact    = "haris-zaf@hcmr.gr"
LABEL build_date = "2021-30-11"
LABEL version    = "v.2.1.4"


# Copy and paste the manually written scripts that PEMA needs
WORKDIR /home/scripts
COPY /scripts/ ./
RUN chmod -R +777 /home/scripts

WORKDIR /home/modules
COPY /modules/ ./
RUN chmod -R +777 /home/modules

# Copy and paste the PEMA script!
WORKDIR /home
COPY pema_latest.bds .


## Make a source of the .bashrc file
WORKDIR /root
RUN echo "export PATH=$PATH:/home/tools/BDS/.bds" >> /root/.bashrc
RUN ["/bin/bash", "-c", "-l",  "source /root/.bashrc"]

RUN export PATH=$PATH:/home/tools/BDS/.bds
ENV PATH=$PATH:/home/tools/BDS/.bds

# Walk around so ncbi-taxonomist can be used in Singularity containers
RUN ln -s /opt/miniconda3/bin/ncbi-taxonomist /home/tools/ncbi-taxonomist

# Rename PR2 db files
WORKDIR /home/tools/CREST/LCAClassifier/parts/flatdb/PR2_DB
RUN mv PR2_DB.fasta pr2.fasta && \
    mv PR2_DB.map  pr2.map && \
    mv PR2_DB.nhr  pr2.nhr && \
    mv PR2_DB.nin  pr2.nin && \
    mv PR2_DB.nsq  pr2.nsq && \
    mv PR2_DB.tre  pr2.tre

WORKDIR /home/tools/CREST/LCAClassifier/parts/flatdb/
RUN mv PR2_DB pr2


# Set "home" as my working directory when a container starts