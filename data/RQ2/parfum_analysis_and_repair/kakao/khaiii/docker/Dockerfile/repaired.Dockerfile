FROM pytorch/pytorch:latest
MAINTAINER nako.sung@navercorp.com

RUN git clone https://github.com/kakao/khaiii.git
WORKDIR /workspace/khaiii

RUN pip install --no-cache-dir cython
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir build
WORKDIR /workspace/khaiii/build

RUN cmake ..
RUN make all
RUN make resource

RUN apt-get update -y && apt-get install --no-install-recommends -y language-pack-ko && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
