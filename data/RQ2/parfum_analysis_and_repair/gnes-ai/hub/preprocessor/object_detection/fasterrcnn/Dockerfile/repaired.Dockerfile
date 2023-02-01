FROM pytorch/pytorch:1.1.0-cuda10.0-cudnn7.5-runtime

RUN pip install --no-cache-dir torch==1.2.0 torchvision==0.4.0

RUN pip install -U gnes --no-cache-dir --compile

ADD *.py *.yml *.zip ./

RUN apt-get update && apt-get install --no-install-recommends -y libsm6 libxext6 wget \
	&& rm -rf /var/lib/apt/lists/*

RUN cd /; mkdir checkpoints \
	&& cd /checkpoints \
	&& wget -q https://download.pytorch.org/models/fasterrcnn_resnet50_fpn_coco-258fb6c6.pth

RUN pip install --no-cache-dir opencv_python >=4.1.0 scipy

RUN python -m unittest test_fasterrcnn.py -v

ENTRYPOINT ["gnes", "preprocess", "--yaml_path", "preprocessor.fasterrcnn.yml", "--read_only"]
