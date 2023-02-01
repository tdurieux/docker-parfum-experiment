FROM public.ecr.aws/lambda/python:3.8
RUN pip3 install --no-cache-dir psycopg2-binary
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY app.py rds_config.py ./
CMD ["app.handler"]