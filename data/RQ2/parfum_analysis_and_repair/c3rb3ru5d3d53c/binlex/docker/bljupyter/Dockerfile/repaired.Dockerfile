FROM tensorflow/tensorflow:2.7.0-gpu-jupyter

ENV LC_ALL=C
ENV DEBIAN_FRONTEND=noninteractive

COPY . $HOME/binlex/

WORKDIR $HOME/binlex/

RUN apt-get -qq -y update && \
    apt-get install --no-install-recommends -qq -y build-essential make cmake git libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN python -m pip install -v .

RUN pip install --no-cache-dir pymongo==4.0.1 pika==1.2.0 minio==7.1.2

CMD jupyter notebook --ip 0.0.0.0 --port 8888 --no-browser --notebook-dir=/tf/notebooks/
