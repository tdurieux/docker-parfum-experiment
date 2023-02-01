# Tensorflow
FROM tensorflow/tensorflow:latest-py3

RUN apt-get -y update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir jupyter matplotlib nbconvert

RUN pip install --no-cache-dir ludwig[full]
RUN pip install --no-cache-dir ludwig[test]

RUN groupadd -g 1000 ec2-user && \
    useradd -u 1000 -g 1000 ec2-user && \
    mkdir -p /home/ec2-user && \
    chown ec2-user:ec2-user /home/ec2-user

WORKDIR /opt/project
