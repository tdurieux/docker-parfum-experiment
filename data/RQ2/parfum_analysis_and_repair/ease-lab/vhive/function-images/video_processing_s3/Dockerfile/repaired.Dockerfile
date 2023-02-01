FROM denismakogon/opencv3-slim:edge as var_workload

RUN apt update && apt -y --no-install-recommends install libgl1-mesa-glx libglib2.0-0 && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir minio && pip3 install --no-cache-dir grpcio && pip3 install --no-cache-dir opencv-python && pip3 install --no-cache-dir protobuf

COPY *.py /

EXPOSE 50051

STOPSIGNAL SIGKILL

CMD ["/usr/local/bin/python3", "/server.py"]
