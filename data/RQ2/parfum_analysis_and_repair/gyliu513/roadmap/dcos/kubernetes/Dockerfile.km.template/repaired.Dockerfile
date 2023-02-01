MAINTAINER Klaus Ma <klaus1982.cn@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -yq supervisor && rm -rf /var/lib/apt/lists/*;

WORKDIR $K8S_HOME

ENTRYPOINT ["./bootstrap.sh"]

