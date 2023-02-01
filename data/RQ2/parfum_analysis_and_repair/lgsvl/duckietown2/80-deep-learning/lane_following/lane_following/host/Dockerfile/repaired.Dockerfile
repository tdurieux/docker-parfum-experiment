FROM tensorflow/tensorflow:latest-devel-gpu

MAINTAINER David Uhm <david.uhm@lge.com>

RUN apt-get update && apt-get install --no-install-recommends -y python-opencv vim && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt /requirements.txt

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r /requirements.txt

EXPOSE 8888

VOLUME [".:/notebooks"]

WORKDIR /notebooks

CMD [ "/run_jupyter.sh", "--allow-root" ]
