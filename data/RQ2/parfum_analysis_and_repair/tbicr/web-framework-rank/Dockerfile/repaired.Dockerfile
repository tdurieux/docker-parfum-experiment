FROM public.ecr.aws/lambda/python:3.8

COPY main.py requirements.txt /var/task/

RUN yum update -y \
 && yum install git -y \
 && yum clean all \
 && pip install --no-cache-dir -r /var/task/requirements.txt && rm -rf /var/cache/yum

CMD [ "main.lambda_handler" ]
