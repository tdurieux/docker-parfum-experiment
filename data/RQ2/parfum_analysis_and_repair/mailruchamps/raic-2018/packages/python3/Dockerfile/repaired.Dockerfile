FROM python:3.7.1

RUN pip install --no-cache-dir numpy scipy cython numba
RUN pip install --no-cache-dir https://download.pytorch.org/whl/cpu/torch-1.0.0-cp37-cp37m-linux_x86_64.whl

COPY . /project
WORKDIR /project
