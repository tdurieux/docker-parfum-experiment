FROM tensorflow/tensorflow:latest
RUN pip install --no-cache-dir flask
ADD startup.sh /
ADD server.py /
ADD patch_tensorboard.py /
EXPOSE 8889
# TODO: move from cmd to entrypoint
ENTRYPOINT ["/bin/bash", "/startup.sh"]