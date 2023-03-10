FROM alpine:latest

WORKDIR /opt/doods

# Download sample models
RUN mkdir models
RUN wget https://storage.googleapis.com/download.tensorflow.org/models/tflite/coco_ssd_mobilenet_v1_1.0_quant_2018_06_29.zip && unzip coco_ssd_mobilenet_v1_1.0_quant_2018_06_29.zip && rm coco_ssd_mobilenet_v1_1.0_quant_2018_06_29.zip && mv detect.tflite models/coco_ssd_mobilenet_v1_1.0_quant.tflite && rm labelmap.txt
RUN wget https://dl.google.com/coral/canned_models/coco_labels.txt && mv coco_labels.txt models/coco_labels0.txt
RUN wget https://download.tensorflow.org/models/object_detection/faster_rcnn_inception_v2_coco_2018_01_28.tar.gz && tar -zxvf faster_rcnn_inception_v2_coco_2018_01_28.tar.gz faster_rcnn_inception_v2_coco_2018_01_28/frozen_inference_graph.pb --strip=1 --no-same-owner && mv frozen_inference_graph.pb models/faster_rcnn_inception_v2_coco_2018_01_28.pb && rm faster_rcnn_inception_v2_coco_2018_01_28.tar.gz
RUN wget https://raw.githubusercontent.com/amikelive/coco-labels/master/coco-labels-2014_2017.txt && mv coco-labels-2014_2017.txt models/coco_labels1.txt

# Add base config
ADD config.yaml config.yaml
