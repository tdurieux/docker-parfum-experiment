FROM jupyter/datascience-notebook
USER root
ADD https://dl.min.io/server/minio/release/linux-amd64/minio /
ADD docker/init.sh /
ADD ./ /ml-git
ADD docker/local_server.git.tar.gz /
ADD docker/local_ml_git_config_server.git.tar.gz /
ADD docker/mlgit.tar.gz /data/

ENV MINIO_ACCESS_KEY=fake_access_key \
    MINIO_SECRET_KEY=fake_secret_key

WORKDIR /ml-git

RUN apt-get install -y --no-install-recommends gcc g++ git && \
    pip install --no-cache-dir mlxtend && \
    rm -rf docker && \
    chmod +x ../minio && \
    chmod +x ../init.sh && \
    sed -i -e 's/\r//g'  ../init.sh && \
    mkdir $HOME/.aws && \
    mkdir /data/faces_bucket && \
    echo -e "[default]\naws_access_key_id = fake_access_key\naws_secret_access_key = fake_secret_key" > $HOME/.aws/credentials && \
    pip install --no-cache-dir -e . && rm -rf /var/lib/apt/lists/*;

WORKDIR ../api_scripts/mnist_notebook

RUN ml-git clone /local_ml_git_config_server.git

ADD docs/api/api_scripts ../
ADD docs/api/api_scripts/mnist_notebook/enriched_mnist.tar.gz ../mnist_notebook/

WORKDIR /workspace

ENTRYPOINT [ "sh", "/init.sh" ]