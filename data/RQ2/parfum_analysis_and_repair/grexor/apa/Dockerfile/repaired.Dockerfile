FROM groovy

MAINTAINER Gregor Rot <gregor.rot@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Zurich

USER root
RUN apt update
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rna-star && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y samtools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxml2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pysam
RUN pip3 install --no-cache-dir numpy
RUN pip3 install --no-cache-dir matplotlib==3.2
RUN pip3 install --no-cache-dir regex
RUN pip3 install --no-cache-dir pandas
RUN pip3 install --no-cache-dir HTSeq

# R
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
RUN apt install --no-install-recommends -y r-base r-base-core r-recommended r-base-dev && rm -rf /var/lib/apt/lists/*;
RUN R -e 'install.packages("BiocManager")'
RUN R -e 'BiocManager::install("edgeR")'
RUN R -e 'BiocManager::install("DEXSeq")'
RUN R -e 'install.packages("data.table")'

# apauser
RUN useradd -m -d /home/apauser apauser
ADD . /home/apauser/apa
RUN chown -R apauser.apauser /home/apauser

USER apauser
WORKDIR /home/apauser
RUN mkdir ~/data
RUN echo "alias python='python3'" >> ~/.bashrc

# salmon
RUN mkdir ~/software
RUN wget https://github.com/COMBINE-lab/salmon/releases/download/v1.4.0/salmon-1.4.0_linux_x86_64.tar.gz -O ~/software/salmon.tgz
WORKDIR /home/apauser/software
RUN tar xfz salmon.tgz && rm salmon.tgz
RUN rm salmon.tgz
RUN mv salmon-latest_linux_x86_64/ salmon

# paths
RUN echo "export PATH=$PATH:/home/apauser/apa/bin:/home/apauser/pybio/bin:~/software/salmon/bin" >> ~/.bashrc
RUN echo "export PYTHONPATH=$PYTHONPATH:/home/apauser" >> ~/.bashrc

WORKDIR /home/apauser

# pybio
RUN git clone https://github.com/grexor/pybio.git
RUN ln -s /home/apauser/data /home/apauser/pybio/genomes/data
RUN echo "pybio.path.genomes_folder='/home/apauser/pybio/genomes/data/genomes'" >> /home/apauser/pybio/config/config.txt
RUN echo "apa.path.data_folder='/home/apauser/data/libs'" >> /home/apauser/apa/config/config.txt
RUN echo "apa.path.comps_folder='/home/apauser/data/comps'" >> /home/apauser/apa/config/config.txt
RUN echo "apa.path.polya_folder='/home/apauser/data/polya'" >> /home/apauser/apa/config/config.txt
