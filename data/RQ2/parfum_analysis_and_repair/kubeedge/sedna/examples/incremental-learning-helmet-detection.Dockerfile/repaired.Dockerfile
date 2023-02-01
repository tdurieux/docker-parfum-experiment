FROM tensorflow/tensorflow:1.15.4

RUN apt update \
  && apt install --no-install-recommends -y libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;

COPY ./lib/requirements.txt /home
# install requirements of sedna lib
RUN pip install --no-cache-dir -r /home/requirements.txt

# extra requirements for example
RUN pip install --no-cache-dir tqdm==4.56.0
RUN pip install --no-cache-dir matplotlib==3.3.3
RUN pip install --no-cache-dir opencv-python==4.4.0.44
RUN pip install --no-cache-dir Pillow==8.0.1

ENV PYTHONPATH "/home/lib"

WORKDIR /home/work
COPY ./lib /home/lib

COPY examples/incremental_learning/helmet_detection/training/  /home/work/


ENTRYPOINT ["python"]
