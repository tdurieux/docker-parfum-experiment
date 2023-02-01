FROM python:3.6.5

ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install --no-install-recommends -y python python-pip python-dev libpq-dev libjpeg-dev libyaml-dev libffi-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /code

RUN git clone https://github.com/Cloud-CV/EvalAI.git /code/

WORKDIR /code

RUN pip install --no-cache-dir -U cffi service_identity cython==0.29 numpy==1.14.5
RUN pip install --no-cache-dir -r requirements/dev.txt
RUN pip install --no-cache-dir -r requirements/worker.txt

ADD . /code

CMD ["python", "-m", "scripts.workers.submission_worker"]
