ARG FROM_IMAGE_NAME=nvcr.io/nvidia/pytorch:21.11-py3
FROM ${FROM_IMAGE_NAME}

ADD ./requirements.txt .
RUN pip install --no-cache-dir --disable-pip-version-check -r requirements.txt
RUN pip install --no-cache-dir monai==0.8.1 --no-dependencies
RUN pip uninstall -y torchtext
RUN pip install --no-cache-dir numpy --upgrade

RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip -qq awscliv2.zip
RUN ./aws/install
RUN rm -rf awscliv2.zip aws

WORKDIR /workspace/nnunet_pyt
ADD . /workspace/nnunet_pyt
