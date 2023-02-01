FROM nytimes/blender:3.1-gpu-ubuntu18.04

LABEL Author="Lei Yang <DIYer22@GitHub>"
LABEL Title="bpycv in Docker"

RUN apt-get update && apt install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

RUN ${BLENDERPY} -m pip install --no-cache-dir -U pip setuptools wheel
# RUN ${BLENDERPY} -m pip install --no-cache-dir -U ipython
RUN ${BLENDERPY} -m pip install --no-cache-dir bpycv && ${BLENDERPY} -m pip uninstall bpycv -y
RUN ln -s ${BLENDERPY} /usr/bin/python
COPY . /bpycv/
WORKDIR /bpycv
RUN ${BLENDERPY} -m pip install --no-cache-dir -r requirements.txt
RUN ${BLENDERPY} setup.py install
WORKDIR /tmp
CMD blender -b -E CYCLES -P /bpycv/example/6d_pose_demo.py && sh /bpycv/example/run_ycb_demo.sh
