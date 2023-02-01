FROM python:3.6-slim

RUN apt update \
  && apt install --no-install-recommends -y gcc libgl1-mesa-glx git libglib2.0-0 libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*;

COPY ./lib/requirements.txt /home

RUN python -m pip install --upgrade pip

RUN pip install --no-cache-dir -r /home/requirements.txt

ENV PYTHONPATH "/home/lib:/home/plato:/home/plato/packages/yolov5"

COPY ./lib /home/lib
RUN git clone https://github.com/TL-System/plato.git /home/plato
RUN rm -rf /home/plato/.git

RUN pip install --no-cache-dir -r /home/plato/requirements.txt
RUN pip install --no-cache-dir -r /home/plato/packages/yolov5/requirements.txt

WORKDIR /home/work
COPY examples/federated_learning/yolov5_coco128_mistnet   /home/work/

ENTRYPOINT ["python", "train.py"]
