FROM python:3.7

RUN apt-get -y update && apt-get -y upgrade
RUN python -m pip install --upgrade pip
RUN python -m pip install numpy onnx psutil coloredlogs sympy onnxconverter_common docker==5.0.0 six

COPY requirements.txt requirements.txt

RUN python -m pip install -r requirements.txt -f https://download.pytorch.org/whl/torch_stable.html
RUN python -m pip install onnxruntime-olive==0.4.0 -f https://olivewheels.azureedge.net/test/onnxruntime-olive

ADD . /code
COPY ThirdPartyNotices.txt /code/ThirdPartyNotices.txt

WORKDIR /mnt
