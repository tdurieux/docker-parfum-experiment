FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y python-setuptools python-dev build-essential python-pip && rm -rf /var/lib/apt/lists/*;
ADD . /
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r /requirements.txt
ENTRYPOINT ["python", "app.py"]
EXPOSE 8000
