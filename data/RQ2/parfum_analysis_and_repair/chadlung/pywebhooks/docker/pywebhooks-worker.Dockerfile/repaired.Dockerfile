FROM python:3.6-slim

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user
WORKDIR /home/user

COPY . /home/user/pywebhooks-worker
WORKDIR /home/user/pywebhooks-worker

RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -e .

USER user
CMD ["celery", "worker"]
