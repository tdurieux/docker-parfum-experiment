FROM python:2.7
MAINTAINER Vyacheslav Tykhonov
COPY . /
WORKDIR /
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
