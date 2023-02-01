FROM linuxbrew/linuxbrew
MAINTAINER Jon Palmer <nextgenusfs@gmail.com>

RUN sudo apt-get update && \
	sudo apt-get install --fix-missing -y build-essential ncbi-blast+ cmake autoconf \
	autogen pigz xvfb default-jre wget zlib1g-dev libboost-all-dev && \
    sudo rm -rf /var/lib/apt/lists/*

USER linuxbrew	

ENV PATH=/home/linuxbrew:/home/linuxbrew/funannotate:/home/linuxbrew/conda/bin:/home/linuxbrew/conda/bin/ete3_apps/bin:/home/linuxbrew/augustus/bin:/home/linuxbrew/braker:/home/linuxbrew/gm_et_linux_64/gmes_petap:/home/linuxbrew/signalp-4.1:/home/linuxbrew/phobius:/home/linuxbrew/Trinity:/home/linuxbrew/RapMap/bin:/home/linuxbrew/trnascan/bin:/home/linuxbrew/nseg:/home/linuxbrew/repeatmasker:/home/linuxbrew/rmblast:/home/linuxbrew/repeatmodeler:/home/linuxbrew/repeatscout:/home/linuxbrew/recon/scripts:/home/linuxbrew/proteinortho:/home/linuxbrew/CodingQuarry_v2.0:$PATH \
    MAFFT_BINARIES=/home/linuxbrew/conda/bin/ete3_apps/bin \
    AUGUSTUS_CONFIG_PATH=/home/linuxbrew/augustus/config \
    EVM_HOME=/home/linuxbrew/evidencemodeler \
    GENEMARK_PATH=/home/linuxbrew/gm_et_linux_64/gmes_petap \
    BAMTOOLS_PATH=/usr/local/bin \
    PASAHOME=/home/linuxbrew/PASApipeline \
    TRINITYHOME=/home/linuxbrew/Trinity \
    FUNANNOTATE_DB=/home/linuxbrew/DB \
	QUARRY_PATH=/home/CodingQuarry_v2.0/QuarryFiles
	
COPY repeatmodeler.txt \
    repeatmasker.txt \
    phobius.tar.gz \
    funannotate-genemark.tar.gz \
    /home/linuxbrew/

WORKDIR /home/linuxbrew

RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    sudo /bin/bash ~/miniconda.sh -b -p /home/linuxbrew/conda &&  rm ~/miniconda.sh && sudo chown -R linuxbrew: /home/linuxbrew/conda && \
    conda update -y conda && conda config --add channels r && conda config --add channels defaults && \
    conda config --add channels etetoolkit && conda config --add channels conda-forge && conda config --add channels bioconda && \
    conda install -y numpy pandas scipy matplotlib seaborn natsort scikit-learn psutil biopython requests \
    goatools fisher bedtools blat hmmer exonerate diamond tbl2asn hisat2 ucsc-pslcdnafilter stringtie perl-dbd-sqlite \
    samtools raxml trimal mafft phyml kallisto bowtie2 infernal perl-threaded perl-db-file perl-bioperl perl-dbd-mysql \
    perl-app-cpanminus mummer ete3 ete_toolchain minimap2 salmon=0.9.1 jellyfish htslib nano perl-text-soundex perl-scalar-util-numeric && \
    conda clean --all && \
    sudo ln -s /home/linuxbrew/conda/bin/ete3_apps/bin/raxmlHPC-PTHREADS-SSE3 /home/linuxbrew/conda/bin/ete3_apps/bin/raxmlHPC-PTHREADS && \
    cpanm Getopt::Long Pod::Usage File::Basename \
    Thread::Queue Carp Data::Dumper YAML Hash::Merge Logger::Simple Parallel::ForkManager \
    DBI Clone JSON LWP::UserAgent && \
    wget https://sourceforge.net/projects/codingquarry/files/CodingQuarry_v2.0.tar.gz && \
    tar -zxvf CodingQuarry_v2.0.tar.gz && rm CodingQuarry_v2.0.tar.gz && cd CodingQuarry_v2.0 && make && cd /home/linuxbrew/ && \
    wget --no-check-certificate https://tandem.bu.edu/trf/downloads/trf409.linux64 && \
    sudo mv trf409.linux64 /usr/local/bin/trf && sudo chmod +x /usr/local/bin/trf && \
    wget http://www.repeatmasker.org/RepeatMasker-open-4-0-7.tar.gz && tar -zxvf RepeatMasker-open-4-0-7.tar.gz && \
    rm RepeatMasker-open-4-0-7.tar.gz && mv RepeatMasker repeatmasker && \
    sudo chmod +x /home/linuxbrew/repeatmasker/RepeatMasker && \
    sudo chmod +x /home/linuxbrew/repeatmasker/util/rmOutToGFF3.pl && \
    sudo ln -s /home/linuxbrew/repeatmasker/util/rmOutToGFF3.pl /home/linuxbrew/repeatmasker/rmOutToGFF3.pl && \
    wget http://www.repeatmasker.org/RepeatModeler/RECON-1.08.tar.gz && tar -zxvf RECON-1.08.tar.gz && \ 
    rm RECON-1.08.tar.gz && mv RECON-1.08 recon && cd recon/src && make && make install && cd /home/linuxbrew/ && \
    sed -i 's,path = \"\";,path = \"/home/linuxbrew/recon/bin\";,g' /home/linuxbrew/recon/scripts/recon.pl && \
    wget http://www.repeatmasker.org/RepeatScout-1.0.5.tar.gz && tar -zxvf RepeatScout-1.0.5.tar.gz && \
    mv RepeatScout-1 repeatscout && cd repeatscout && make && cd /home/linuxbrew/ && \
    wget -r -np -nH -R index.html ftp://ftp.ncbi.nih.gov/pub/seg/nseg/ && \
    cd pub/seg/nseg/ && make && cd /home/linuxbrew/ && mv /home/linuxbrew/pub/seg/nseg /home/linuxbrew/nseg && \
    wget http://www.repeatmasker.org/RepeatModeler/RepeatModeler-open-1.0.11.tar.gz && \
    tar -zxvf RepeatModeler-open-1.0.11.tar.gz && rm RepeatModeler-open-1.0.11.tar.gz && \
    mv RepeatModeler-open-1.0.11 repeatmodeler && \
    wget --no-check-certificate https://www.bioinf.uni-leipzig.de/Software/proteinortho/proteinortho_v5.16b.tar.gz && \
    tar -zxvf proteinortho_v5.16b.tar.gz && mv proteinortho_v5.16b proteinortho && cd proteinortho && \
    find . -name "*.pl" | xargs sed -i 's,#!/usr/bin/perl,#!/usr/bin/env perl,g' && cd /home/linuxbrew/ && \
    wget https://github.com/nextgenusfs/EVidenceModeler/archive/0.1.3.tar.gz && tar -zxvf 0.1.3.tar.gz && \
    rm 0.1.3.tar.gz && mv EVidenceModeler-0.1.3 evidencemodeler && \
    wget https://github.com/pezmaster31/bamtools/archive/v2.5.0.tar.gz && tar -zxvf v2.5.0.tar.gz && \
    rm v2.5.0.tar.gz && mv bamtools-2.5.0 bamtools && cd bamtools && mkdir build && cd build && \
    cmake .. && make && sudo make install && cd /usr/include && \
    sudo ln -f -s ../local/include/bamtools/ && \
    cd /usr/lib/ &&  sudo ln -f -s /usr/local/lib/bamtools/libbamtools.* . && cd /home/linuxbrew/ && \
    wget http://bioinf.uni-greifswald.de/augustus/binaries/augustus-3.3.1.tar.gz && \
    tar -zxvf augustus-3.3.1.tar.gz && rm augustus-3.3.1.tar.gz && mv augustus-3.3.1 augustus && \
    cd augustus && sed -i 's/	cd bam2wig; make/	#cd bam2wig; make/g' /home/linuxbrew/augustus/auxprogs/Makefile && \
    make clean && make && cd /home/linuxbrew/ && \
    wget https://github.com/trinityrnaseq/trinityrnaseq/archive/Trinity-v2.6.6.tar.gz && \
    tar -zxvf Trinity-v2.6.6.tar.gz && rm Trinity-v2.6.6.tar.gz && \
    mv trinityrnaseq-Trinity-v2.6.6 Trinity && cd Trinity && make && make plugins && cd /home/linuxbrew/ && \
    wget http://research-pub.gene.com/gmap/src/gmap-gsnap-2017-06-20.tar.gz && \
    tar -zxvf gmap-gsnap-2017-06-20.tar.gz && rm gmap-gsnap-2017-06-20.tar.gz && \
    mv gmap-2017-06-20/ gmap && cd gmap/ && ./configure && make && sudo make install && cd /home/linuxbrew/ && rm -r gmap && \
    wget https://github.com/PASApipeline/PASApipeline/releases/download/pasa-v2.3.3/PASApipeline-v2.3.3.tar.gz && \
    tar -zxvf PASApipeline-v2.3.3.tar.gz && rm PASApipeline-v2.3.3.tar.gz && \
    mv PASApipeline-v2.3.3 PASApipeline && cd PASApipeline && make clean && make && \
    sed -i 's/gene_id varchar(1000)/gene_id varchar(800)/g' /home/linuxbrew/PASApipeline/schema/cdna_alignment_mysqlschema && \
    cd /home/linuxbrew/ && \
    wget http://faculty.virginia.edu/wrpearson/fasta/fasta36/fasta-36.3.8e.tar.gz && \
    tar -zxvf fasta-36.3.8e.tar.gz && rm fasta-36.3.8e.tar.gz && \
    cd fasta-36.3.8e/src && make -f ../make/Makefile.linux fasta36 && cd /home/linuxbrew/ && \
    ln -s /home/linuxbrew/fasta-36.3.8e/bin/fasta36 /home/linuxbrew/conda/bin/fasta && \
    wget http://trna.ucsc.edu/software/trnascan-se-2.0.0.tar.gz && \
    tar -zxvf trnascan-se-2.0.0.tar.gz && rm trnascan-se-2.0.0.tar.gz && \
    mv tRNAscan-SE-2.0 tRNAscan-SE && cd tRNAscan-SE && ./configure --prefix=/home/linuxbrew/trnascan && \
    make && make install && cd /home/linuxbrew/ rm -r tRNAscan-SE && \
    ln -s /home/linuxbrew/conda/bin/cmscan /home/linuxbrew/trnascan/bin/ && \
    ln -s /home/linuxbrew/conda/bin/cmsearch /home/linuxbrew/trnascan/bin/ && \
    tar -zxvf phobius.tar.gz && tar -zxvf funannotate-genemark.tar.gz && \
    brew update && brew install blast brewsci/bio/rmblast brewsci/bio/iqtree && \
    brew cleanup && rm /home/linuxbrew/.linuxbrew/bin/tblastn
       
COPY pasa_conf.txt /home/linuxbrew/PASApipeline/pasa_conf/conf.txt

RUN wget https://github.com/nextgenusfs/funannotate/archive/1.5.3.tar.gz && \
    tar -zxvf 1.5.3.tar.gz && rm 1.5.3.tar.gz && mv funannotate-1.5.3 funannotate
