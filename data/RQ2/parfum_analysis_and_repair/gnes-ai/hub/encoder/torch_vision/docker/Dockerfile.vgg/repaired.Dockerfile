FROM pytorch/pytorch:1.1.0-cuda10.0-cudnn7.5-runtime

RUN pip install --no-cache-dir torch==1.2.0 torchvision==0.4.0 scipy

RUN pip install -U gnes --no-cache-dir --compile

ADD test_vgg.py encoder.vgg.yml ./

RUN apt-get update && apt-get install --no-install-recommends -y wget \
	&& rm -rf /var/lib/apt/lists/*

RUN cd /; mkdir checkpoints \
	&& cd /checkpoints \
	&& wget -q https://download.pytorch.org/models/vgg16-397923af.pth

RUN python -m unittest test_vgg.py -v

ENTRYPOINT ["gnes", "encode", "--yaml_path", "encoder.vgg.yml", "--read_only"]