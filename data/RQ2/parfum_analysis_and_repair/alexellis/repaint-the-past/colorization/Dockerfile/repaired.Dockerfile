FROM bvlc/caffe:cpu

RUN apt-get update -qqy \
    && apt-get install --no-install-recommends -qy \
        unzip \
        python-tk \
        curl -qy \
    && pip install --no-cache-dir minio && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p models resources \
    && curl -f -sL https://github.com/richzhang/colorization/raw/master/resources/pts_in_hull.npy > ./resources/pts_in_hull.npy \
    && curl -f -sL https://eecs.berkeley.edu/~rich.zhang/projects/2016_colorization/files/demo_v2/colorization_release_v2.caffemodel > ./models/colorization_release_v2.caffemodel \
    && curl -f -sL https://raw.githubusercontent.com/richzhang/colorization/master/models/colorization_deploy_v2.prototxt > ./models/colorization_deploy_v2.prototxt

RUN curl -f -sSL https://github.com/openfaas/faas/releases/download/0.13.4/fwatchdog > /usr/bin/fwatchdog \
    && chmod +x /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

ENV fprocess="python -u index.py"
ENV read_timeout="60"
ENV write_timeout="60"

RUN pip install --no-cache-dir requests

COPY index.py index.py
COPY handler.py handler.py

CMD ["fwatchdog"]
