FROM tensorflow/tensorflow:1.15.5-gpu-py3
RUN mkdir -p /app /app/models

EXPOSE 6006
WORKDIR /app
CMD tensorboard --logdir models/