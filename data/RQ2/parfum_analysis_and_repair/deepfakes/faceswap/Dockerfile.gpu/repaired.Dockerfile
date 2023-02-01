FROM nvidia/cuda:11.7.0-runtime-ubuntu18.04
ARG DEBIAN_FRONTEND=noninteractive

#install python3.8
RUN apt-get update
RUN apt-get install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get update
RUN apt-get install --no-install-recommends python3.8 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3.8-distutils -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3.8-tk -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3.8 get-pip.py
RUN rm get-pip.py

# install requirements
RUN apt-get install --no-install-recommends ffmpeg git -y && rm -rf /var/lib/apt/lists/*;
COPY ./requirements/_requirements_base.txt /opt/
COPY ./requirements/requirements_nvidia.txt /opt/
RUN python3.8 -m pip --no-cache-dir install -r /opt/requirements_nvidia.txt && rm /opt/_requirements_base.txt && rm /opt/requirements_nvidia.txt

RUN python3.8 -m pip install jupyter matplotlib tqdm
RUN python3.8 -m pip install jupyter_http_over_ws
RUN jupyter serverextension enable --py jupyter_http_over_ws
RUN alias python=python3.8
RUN echo "alias python=python3.8" >> /root/.bashrc
WORKDIR "/notebooks"
CMD ["jupyter-notebook", "--allow-root" ,"--port=8888" ,"--no-browser" ,"--ip=0.0.0.0"]
