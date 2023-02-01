FROM centos:7
ARG user=cudgx
ARG group=cudgx

RUN groupadd -r $user

ARG app=gf.cudgx.consumer
ARG conf=consumer.json

ARG dir=/home/$user

RUN mkdir -p $dir/bin
RUN mkdir -p $dir/conf

COPY bin/$app $dir/bin/$app
COPY conf/$conf $dir/conf/$conf

EXPOSE 19000

WORKDIR $dir

ENV GIN_MODE=release

ENTRYPOINT ["./bin/gf.cudgx.consumer"]
CMD ["--gf.cudgx.consumer.config=conf/consumer.json"]
