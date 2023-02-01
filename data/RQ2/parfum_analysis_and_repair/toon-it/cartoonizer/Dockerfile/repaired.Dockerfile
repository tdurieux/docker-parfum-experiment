FROM tensorflow/tensorflow:1.15.2

LABEL maintainer="Kurian Benoy<kurian.bkk@gmail.com>"
ENV PYTHONBUFFERED 1

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip --no-cache-dir install --upgrade \
    pip \
    setuptools

ADD . /cartoonizer/
WORKDIR /cartoonizer
RUN pip -V
RUN pip install --no-cache-dir scikit-build
RUN pip install --no-cache-dir -r dev-requirements.txt
EXPOSE 5000

# ENTRYPOINT ["/bin/sh", "entrypoint.sh"]
CMD ["python3", "main.py"]
