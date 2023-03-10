ARG FROM_IMAGE_NAME
FROM ${FROM_IMAGE_NAME}
RUN apt update && apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
WORKDIR /tmp
RUN git clone https://gitee.com/Stan.Xu/gflags && cd gflags/ && mkdir build &&cd build &&cmake .. && make install

COPY requirements.txt .
RUN pip3.7 install -r requirements.txt