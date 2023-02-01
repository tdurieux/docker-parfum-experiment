FROM deepquestai/deepstack-base:cpu-1647248158 as cpu

ENV SLEEP_TIME 0.01
ENV TIMEOUT 60
ENV SEND_LOGS True
ENV CUDA_MODE False
ENV APPDIR /app

RUN mkdir /deeptemp
RUN mkdir /datastore

ENV DATA_DIR /datastore
ENV TEMP_PATH /deeptemp/
ENV PROFILE desktop_cpu

WORKDIR /app

RUN wget https://go.dev/dl/go1.17.6.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.6.linux-amd64.tar.gz && rm go1.17.6.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
RUN rm go1.17.6.linux-amd64.tar.gz

RUN pip install --no-cache-dir onnxruntime==0.4.0

RUN pip3 install --no-cache-dir redis
RUN pip3 install --no-cache-dir opencv-python
RUN pip3 install --no-cache-dir Cython
RUN pip3 install --no-cache-dir pillow
RUN pip3 install --no-cache-dir scipy
RUN pip3 install --no-cache-dir tqdm
RUN pip3 install --no-cache-dir tensorboard
RUN pip3 install --no-cache-dir PyYAML
RUN pip3 install --no-cache-dir Matplotlib
RUN pip3 install --no-cache-dir easydict
RUN pip3 install --no-cache-dir future
RUN pip3 install --no-cache-dir numpy

RUN mkdir /app/sharedfiles
COPY ./sharedfiles/yolov5m.pt /app/sharedfiles/yolov5m.pt
COPY ./sharedfiles/face.pt /app/sharedfiles/face.pt
COPY ./sharedfiles/facerec-high.model /app/sharedfiles/facerec-high.model
COPY ./sharedfiles/scene.pt /app/sharedfiles/scene.pt
COPY ./sharedfiles/categories_places365.txt /app/sharedfiles/categories_places365.txt
COPY ./sharedfiles/bebygan_x4.pth /app/sharedfiles/bebygan_x4.pth

RUN mkdir /app/server
COPY ./server /app/server
WORKDIR /app/server
RUN go build
WORKDIR /app

RUN mkdir /app/intelligencelayer
COPY ./intelligencelayer /app/intelligencelayer

COPY ./init.py /app

EXPOSE 5000

WORKDIR /app/server

CMD ["/app/server/server"]
