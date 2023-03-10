# Base image
FROM compbio/ngseasy-base:1.0

# Maintainer
MAINTAINER Stephen Newhouse stephen.j.newhouse@gmail.com

# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Remain current
RUN apt-get update && \
  apt-get upgrade -y

#---------------------------------------------annotation-------------------------------------------------

# + ANNOVAR (see licence, and registration)
# Available on reg:  http://www.openbioinformatics.org/annovar/download/0wgxR2rIVP/annovar.latest.tar.gz
# 11.2014 : http://www.openbioinformatics.org/annovar/download/0wgxR2rIVP/annovar.latest.tar.gz

RUN wget -O /tmp/annovar.latest.tar.gz https://www.openbioinformatics.org/annovar/download/0wgxR2rIVP/annovar.latest.tar.gz \
  && tar xzvf /tmp/annovar.latest.tar.gz -C /usr/local/pipeline/ \
  && sed -i '$aPATH=${PATH}:/usr/local/pipeline/annovar' /home/pipeman/.bashrc \
  && echo "alias ngsAnnovar='/usr/local/pipeline/annovar'" >> /home/pipeman/.bashrc && rm /tmp/annovar.latest.tar.gz

#----------------------------------Basic Databases-----------------------------
# COPY Files
COPY get_annovar_databases.sh /usr/local/pipeline/annovar/
COPY get_annovar_gene_databases.sh /usr/local/pipeline/annovar/

# RUN Them
# RUN /bin/bash /usr/local/pipeline/annovar/get_annovar_gene_databases.sh && /bin/bash /usr/local/pipeline/annovar/get_annovar_databases.sh

#-------------------------------PERMISSIONS--------------------------
RUN chmod -R 776 /usr/local/pipeline/
RUN chown -R pipeman:ngsgroup /usr/local/pipeline
RUN adduser pipeman sudo
RUN usermod -a -G sudo pipeman

#---------------------------------------------------------------------------------
# Cleanup the temp dir
RUN rm -rf /tmp/*

# open ports private only
EXPOSE 8080

# Use baseimage-docker's bash.
CMD ["/bin/bash"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get autoclean && apt-get autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/
