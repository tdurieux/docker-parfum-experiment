FROM sysstacks/dlrs-pytorch-clearlinux:v0.6.0-oss

ARG stage 
ENV STAGE=$stage

WORKDIR /workdir
COPY python/ python/
COPY scripts/entrypoint.sh .

RUN chmod +x entrypoint.sh

EXPOSE 5059

ENTRYPOINT ["./entrypoint.sh"]