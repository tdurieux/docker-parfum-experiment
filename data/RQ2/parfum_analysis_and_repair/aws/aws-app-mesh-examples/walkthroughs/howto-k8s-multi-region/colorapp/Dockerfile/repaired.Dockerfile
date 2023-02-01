FROM public.ecr.aws/bitnami/python:latest

COPY serve.py ./
RUN chmod +x ./serve.py
RUN pip install --no-cache-dir requests
CMD ["python", "-u", "./serve.py"]
