FROM ffn-base 

LABEL maintainer="Jordan Matelsky <jordan.matelsky@jhuapl.edu>"

WORKDIR "ffn"
COPY ./train/main.sh .

ENTRYPOINT ["bash", "-c", "./main.sh"]