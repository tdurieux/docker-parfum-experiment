FROM centos:7
ARG user=cudgx
ARG group=cudgx

RUN groupadd -r $user

ARG app=gf.cudgx.sample.benchmark

ARG dir=/home/$user

RUN mkdir -p $dir/bin

COPY bin/$app $dir/bin/$app

WORKDIR $dir

ENTRYPOINT ["./bin/gf.cudgx.sample.benchmark"]
CMD ["--gf.cudgx.sample.benchmark.sever-address=http://localhost:8090","--gf.cudgx.sample.benchmark.concurrency=1"]
