FROM pytorch/pytorch:1.5.1-cuda10.1-cudnn7-runtime

RUN apt-get update && apt-get -y --no-install-recommends install python3-gdbm && rm -rf /var/lib/apt/lists/*;
RUN cp /usr/lib/python3.7/lib-dynload/_gdbm.cpython-37m-x86_64-linux-gnu.so /opt/conda/lib/python3.7/lib-dynload/

RUN pip install --no-cache-dir jupyter seaborn matplotlib==3.1.3

COPY . .
RUN pip install --no-cache-dir -e .[dev]