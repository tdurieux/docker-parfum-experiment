FROM python:3.7.13-slim-buster

RUN apt-get update -y
RUN apt install --no-install-recommends gcc g++ git wget -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends ffmpeg libsm6 libxext6 - && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir setuptools cython numpy

WORKDIR /workspace
RUN git clone https://github.com/Arthur151/ROMP.git

WORKDIR /workspace/ROMP/simple_romp
RUN python setup.py install

# run this part to download weights automaticly
WORKDIR /
RUN wget https://im.rediff.com/sports/2011/aug/13pic1.jpg
RUN romp --mode=image --input 13pic1.jpg -o . --render_mesh
RUN romp --mode=image --input 13pic1.jpg -o . --render_mesh --onnx

ENTRYPOINT [ "romp" ]
