FROM public.ecr.aws/lambda/python:3.8

RUN yum install -y libgomp && rm -rf /var/cache/yum

COPY app.py requirements.txt ./
COPY model /opt/ml/model

RUN python3.8 -m pip install -r requirements.txt -t .

CMD ["app.lambda_handler"]
