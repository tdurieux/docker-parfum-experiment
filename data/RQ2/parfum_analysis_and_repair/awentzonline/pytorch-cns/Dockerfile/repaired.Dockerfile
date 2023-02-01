from python:3

RUN apt-get update && apt-get -y --no-install-recommends install python-numpy python-scipy libsdl1.2-dev libsdl-gfx1.2-dev libsdl-image1.2-dev cmake swig && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir http://download.pytorch.org/whl/cu75/torch-0.1.12.post2-cp36-cp36m-linux_x86_64.whl
RUN pip install --no-cache-dir torchvision

ADD . /app
WORKDIR /app
RUN pip install --no-cache-dir -e .
RUN pip install --no-cache-dir -r requirements.examples.txt

CMD ["python", "-u", "examples/atari_pixrnn_gpa.py", "--num-agents=10", "--clear-store", "--redis-params={\"host\": \"redis\"}"]
