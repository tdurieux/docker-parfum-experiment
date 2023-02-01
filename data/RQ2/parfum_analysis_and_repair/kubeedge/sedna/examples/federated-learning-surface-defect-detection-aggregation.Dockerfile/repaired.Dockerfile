FROM tensorflow/tensorflow:2.3.0

RUN apt update \
  && apt install --no-install-recommends -y libgl1-mesa-glx git && rm -rf /var/lib/apt/lists/*;

COPY ./lib/requirements.txt /home

RUN python -m pip install --upgrade pip

RUN pip install --no-cache-dir -r /home/requirements.txt
RUN pip install --no-cache-dir keras
RUN pip install --no-cache-dir tensorflow-datasets

ENV PYTHONPATH "/home/lib:/home/plato"

COPY ./lib /home/lib
RUN git clone https://github.com/TL-System/plato.git /home/plato
RUN rm -rf /home/plato/.git

RUN pip install --no-cache-dir -r /home/plato/requirements.txt

WORKDIR /home/work
COPY examples/federated_learning/surface_defect_detection_v2  /home/work/

CMD ["/bin/sh", "-c", "ulimit -n 50000; python aggregate.py"]
