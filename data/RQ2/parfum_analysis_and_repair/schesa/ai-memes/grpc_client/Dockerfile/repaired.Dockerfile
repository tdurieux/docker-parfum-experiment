FROM python:3.8
RUN python -m pip install grpcio
RUN python -m pip install grpcio-tools

RUN pip install --no-cache-dir Pillow
RUN pip install --no-cache-dir tqdm
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir tensorflow
RUN pip install --no-cache-dir matplotlib

RUN mkdir /app
ADD . /app
WORKDIR /app
#
# RUN python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. ./memegenerator.proto

# CMD python /app/grpc_client.py

CMD ["python", "grpc_client.py"]
