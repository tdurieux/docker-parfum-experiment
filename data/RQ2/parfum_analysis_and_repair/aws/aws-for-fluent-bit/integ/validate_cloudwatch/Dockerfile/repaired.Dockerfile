FROM public.ecr.aws/amazonlinux/amazonlinux:latest

RUN yum upgrade -y && yum install -y python3 pip3 && rm -rf /var/cache/yum

RUN pip3 install --no-cache-dir boto3

WORKDIR /usr/local/bin

COPY validator.py .

CMD ["python3", "validator.py"]
