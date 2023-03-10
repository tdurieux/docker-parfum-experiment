FROM tensorflow/serving:latest-gpu

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install python3 python3-pip libsm6 libxrender-dev libxext6 libcap-dev ffmpeg git && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* && \
  pip3 install --no-cache-dir --upgrade pip

ADD requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt && \
  rm requirements.txt

ADD src// /src

ADD serving /models/serving/1
# the 1 is used for versioning the models
# TODO: find a cleaner way to handle this

ADD scripts/up_serving.sh /scripts/up_serving.sh

ENV PYTHONPATH $PYTHONPATH:/src

ENTRYPOINT /scripts/up_serving.sh
