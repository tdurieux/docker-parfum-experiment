FROM public.ecr.aws/lambda/python:3.9

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN yum install -y python-devel && rm -rf /var/cache/yum
COPY build.py ./

CMD ["build.main"]