FROM localhost:5000/darknetiot:latest as darknet

FROM localhost:5000/iot-edge-darknet-base

WORKDIR /

# Copy in required dependencies

COPY --from=darknet /darknet/libdarknet.so /usr/lib/
COPY --from=darknet /darknet/python/darknet.py .
COPY --from=darknet /darknet/yolo.weights .
COPY --from=darknet /darknet/cfg ./cfg
COPY --from=darknet /darknet/data ./data
COPY --from=darknet /darknet/darknet .

RUN apt-get update && apt-get install --no-install-recommends -y libboost-python1.58.0 python-opencv python-pip libcurl3 && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY *.py /

CMD ["python", "-u", "module.py"]
