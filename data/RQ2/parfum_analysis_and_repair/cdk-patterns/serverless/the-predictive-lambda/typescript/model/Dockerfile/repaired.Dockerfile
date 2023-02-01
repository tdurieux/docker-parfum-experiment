FROM public.ecr.aws/lambda/python:3.6
COPY deployment/app.py requirements.txt chipotle.pkl ./
RUN pip3 install --no-cache-dir -r requirements.txt
CMD ["app.lambdaHandler"]