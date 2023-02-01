FROM ubuntu

MAINTAINER Klaus Ma <klaus1982.cn@gmail.com>

RUN mkdir -p /opt/kubernetes

ENV K8S_HOME /opt/kubernetes

COPY kubernetes/_output/local/go/bin $K8S_HOME

COPY bootstrap.sh $K8S_HOME/

RUN chmod +x $K8S_HOME/bootstrap.sh

ENV PATH $K8S_HOME:$PATH


MAINTAINER Klaus Ma <klaus1982.cn@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -yq supervisor && rm -rf /var/lib/apt/lists/*;

WORKDIR $K8S_HOME

ENTRYPOINT ["./bootstrap.sh"]

