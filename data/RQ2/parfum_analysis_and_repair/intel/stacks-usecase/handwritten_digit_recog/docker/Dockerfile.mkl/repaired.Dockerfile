FROM clearlinux/stacks-pytorch-mkl:v0.5.0

ARG stage

ENV PATH=$PATH:/opt/conda/bin/ \
    LD_LIBRARY_PATH=/usr/lib64:/opt/conda/lib \
    STAGE=$stage

WORKDIR /workdir
COPY python/ python/
COPY scripts/entrypoint.sh .
 
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]