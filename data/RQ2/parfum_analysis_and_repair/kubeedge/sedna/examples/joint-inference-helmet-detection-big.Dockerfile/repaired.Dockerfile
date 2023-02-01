FROM tensorflow/tensorflow:1.15.4

RUN apt update \
  && apt install --no-install-recommends -y libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;

COPY ./lib/requirements.txt /home
RUN pip install --no-cache-dir -r /home/requirements.txt
RUN pip install --no-cache-dir opencv-python==4.4.0.44
RUN pip install --no-cache-dir Pillow==8.0.1

ENV PYTHONPATH "/home/lib"

WORKDIR /home/work
COPY ./lib /home/lib

ENTRYPOINT ["python"]

COPY examples/joint_inference/helmet_detection_inference/big_model/big_model.py  /home/work/infer.py
COPY examples/joint_inference/helmet_detection_inference/big_model/interface.py  /home/work/interface.py

CMD ["infer.py"] 
