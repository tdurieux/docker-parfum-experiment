FROM python:3.9

COPY k8spin_operator/requirements.txt /src/requirements.txt
RUN pip install --no-cache-dir -r /src/requirements.txt

COPY k8spin_common /src/k8spin_common
RUN pip install --no-cache-dir -e /src/k8spin_common

COPY k8spin_operator /app/k8spin_operator

ENTRYPOINT [ "kopf", "run" ]
CMD ["/app/k8spin_operator/operator.py"]
