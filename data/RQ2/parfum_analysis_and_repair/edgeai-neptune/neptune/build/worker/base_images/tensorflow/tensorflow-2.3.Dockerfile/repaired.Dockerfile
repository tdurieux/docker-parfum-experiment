FROM tensorflow/tensorflow:2.3.0

RUN apt update \
  && apt install --no-install-recommends -y libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;
COPY ./lib/requirements.txt /home
RUN pip install --no-cache-dir -r /home/requirements.txt

ENV PYTHONPATH "/home/lib"

WORKDIR /home/work
COPY ./lib /home/lib

ENTRYPOINT ["python"]
