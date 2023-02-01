# This Docker container will quantize a frozen graph object detection model and convert it to a quantized and tflite with TOCO tool. you can easily use this container by following these steps:
# 1. docker build -f toco-Dockerfile -t "neuralet/toco" .
# 2. docker run -v [PATH_TO_FROZEN_GRAPH_DIRECTORY]:/model_dir neuralet/toco --graph_def_file=[frozen graph file] 
# by running these command a detect.tflite file is created in the FROZEN_GRAPH_DIRECTORY that is a quantized version of the object detection model.
# you can also override other parameters like input_shapes