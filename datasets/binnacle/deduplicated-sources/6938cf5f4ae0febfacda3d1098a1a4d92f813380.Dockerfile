FROM python:3.4
LABEL maintainer="yang-min.kim@pasteur.fr"
LABEL maintainer="guillaume.dumas@pasteur.fr"
ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
ADD ./stratipy /stratipy
ADD ./data /data
ADD ./reproducibility /reproducibility
WORKDIR /reproducibility
CMD ["python", "-u", "reproducibility.py"]
