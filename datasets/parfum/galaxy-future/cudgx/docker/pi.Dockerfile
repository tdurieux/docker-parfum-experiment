FROM centos:7
ARG user=cudgx
ARG group=cudgx

RUN groupadd -r $user

ARG app=gf.cudgx.sample.pi

ARG dir=/home/$user

RUN mkdir -p $dir/bin

COPY bin/$app $dir/bin/$app

EXPOSE 8090

ENV GIN_MODE=release

WORKDIR $dir

ENTRYPOINT ["./bin/gf.cudgx.sample.pi"]
CMD ["--gf.cudgx.sample.pi.count=50","--gf.cudgx.sample.pi.bind=0.0.0.0:8090"]
