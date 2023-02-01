FROM python:3.7-slim

RUN apt update && apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir 'git+git://github.com/coreweave/kfserving#egg=kfserving&subdirectory=python/kfserving'

ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p transformer/
COPY . transformer/
ENTRYPOINT ["python", "-m", "transformer"]
