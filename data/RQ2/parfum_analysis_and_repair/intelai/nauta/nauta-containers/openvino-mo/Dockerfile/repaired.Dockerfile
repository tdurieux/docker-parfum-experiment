FROM ubuntu:18.04 as build

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

RUN git clone https://github.com/opencv/dldt.git
WORKDIR /root/dldt
RUN git checkout 2018_R5
RUN mv model-optimizer /root

FROM ubuntu:18.04

WORKDIR /root

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip python3-venv libgfortran3 && rm -rf /var/lib/apt/lists/*;

COPY --from=build /root/model-optimizer /root/model-optimizer

COPY requirements.txt nauta-requirements.txt
RUN pip3 install --no-cache-dir --upgrade pip==20.0.2
RUN pip3 install --no-cache-dir -r nauta-requirements.txt

WORKDIR /root/model-optimizer
