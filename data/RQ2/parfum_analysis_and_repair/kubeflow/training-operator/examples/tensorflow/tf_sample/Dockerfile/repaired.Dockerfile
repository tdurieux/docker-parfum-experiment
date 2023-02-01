FROM  tensorflow/tensorflow:1.8.0
RUN pip install --no-cache-dir retrying
RUN mkdir -p /opt/kubeflow
COPY tf_smoke.py /opt/kubeflow/
ENTRYPOINT ["python", "/opt/kubeflow/tf_smoke.py"]
