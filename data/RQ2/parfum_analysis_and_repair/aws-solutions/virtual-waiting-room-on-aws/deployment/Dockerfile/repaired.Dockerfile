FROM public.ecr.aws/amazonlinux/amazonlinux:latest
CMD bash
RUN mkdir -p site-packages/
RUN amazon-linux-extras enable python3.8
RUN yum install -y python3.8 && rm -rf /var/cache/yum
RUN pip3.8 install pip --upgrade
RUN pip install --no-cache-dir -t site-packages/ jwcrypto
