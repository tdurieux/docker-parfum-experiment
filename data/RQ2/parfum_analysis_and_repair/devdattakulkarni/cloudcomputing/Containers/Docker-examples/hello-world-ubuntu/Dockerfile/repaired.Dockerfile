FROM ubuntu:14.04
RUN apt-get update -y \
    && apt-get install --no-install-recommends -y python-setuptools python-pip && rm -rf /var/lib/apt/lists/*;
ADD requirements.txt /src/requirements.txt
RUN cd /src; pip install --no-cache-dir -r requirements.txt
ADD . /src
EXPOSE 5000
CMD ["python", "/src/application.py"]