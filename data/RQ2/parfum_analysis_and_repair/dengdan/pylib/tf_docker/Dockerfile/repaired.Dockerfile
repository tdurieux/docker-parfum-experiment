#FROM tensorflow/tensorflow:1.14.0-gpu-py3
FROM dengdan/tensorflow-gpu:tf14

RUN apt-get update && apt-get install --no-install-recommends -y python3-tk && rm -rf /var/lib/apt/lists/*;

#RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple ujson
