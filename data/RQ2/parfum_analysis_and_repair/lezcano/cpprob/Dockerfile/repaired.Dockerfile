FROM pytorch/pytorch

RUN pip install --no-cache-dir flatbuffers py-cpuinfo pyzmq termcolor

RUN mkdir /code

RUN apt update && apt install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV PYTHONPATH=/code/infcomp
ENV PYTHONIOENCODING=utf8

ADD infcomp /code/infcomp

WORKDIR /code

CMD bash
