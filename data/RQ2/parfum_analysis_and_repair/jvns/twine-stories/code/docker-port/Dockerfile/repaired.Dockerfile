FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir redis flask
ADD code.py /code.py

CMD ["python3", "/code.py"]
