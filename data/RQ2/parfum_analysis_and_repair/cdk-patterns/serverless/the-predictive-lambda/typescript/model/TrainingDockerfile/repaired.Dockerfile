FROM public.ecr.aws/lambda/python:3.6
COPY training/training.py requirements.txt training/chipotle_stores.csv ./
RUN pip3 install --no-cache-dir -r requirements.txt
RUN python3 training.py