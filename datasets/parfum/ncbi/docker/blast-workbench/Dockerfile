FROM ncbi/edirect as edirect
FROM ncbi/magicblast as magicblast
FROM ncbi/blast

LABEL Description="NCBI BLAST tools" \
    Vendor="NCBI/NLM/NIH" \
    URL="https://blast.ncbi.nlm.nih.gov" \
    Maintainer=camacho@ncbi.nlm.nih.gov 

COPY --from=edirect /usr/local/ncbi/edirect /root/edirect
RUN apt-get -y -m update && apt-get install -y curl vmtouch cpanminus libxml-simple-perl libwww-perl libjson-perl libnet-perl && rm -rf /var/lib/apt/lists/* && cpanm HTML::Entities

RUN mkdir -p /magicblast/bin /magicblast/lib
COPY --from=magicblast /blast/bin/magicblast /magicblast/bin/magicblast.REAL
COPY ./magicblast-wrapper.sh /magicblast/bin/magicblast
RUN chmod +x /magicblast/bin/magicblast
COPY --from=magicblast /blast/lib /magicblast/lib

ENV PATH "/root/edirect:/blast/bin:/magicblast/bin:${PATH}"
ENV BLASTDB "/blast/blastdb:/blast/blastdb_custom"
CMD ["/bin/bash"]
