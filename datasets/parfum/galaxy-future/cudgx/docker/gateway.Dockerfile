FROM centos:7
ARG user=cudgx
ARG group=cudgx

RUN groupadd -r $user

ARG app=gf.cudgx.gateway
ARG conf=gateway.json

ARG dir=/home/$user

RUN mkdir -p $dir/bin
RUN mkdir -p $dir/conf

COPY bin/$app $dir/bin/$app
COPY conf/$conf $dir/conf/$conf
WORKDIR $dir

ENV GIN_MODE=release

ENTRYPOINT ["./bin/gf.cudgx.gateway"]
CMD ["--gf.cudgx.gateway.config=conf/gateway.json","--gf.cudgx.gateway.bind=0.0.0.0:8080"]
