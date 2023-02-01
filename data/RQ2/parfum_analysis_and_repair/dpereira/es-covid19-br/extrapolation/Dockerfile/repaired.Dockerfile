FROM python:3

COPY . /extrapolation
RUN pip install --no-cache-dir -r /extrapolation/requirements.txt
