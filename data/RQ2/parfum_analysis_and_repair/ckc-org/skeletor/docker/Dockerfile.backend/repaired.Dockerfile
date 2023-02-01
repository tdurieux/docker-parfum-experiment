FROM python:3.10.5

# gcc, build-essential, python-setuptools for python installation help
# graphviz, libgraphviz-dev for making diagrams from models
RUN apt-get update && apt-get install --no-install-recommends -yy gcc build-essential python-setuptools graphviz libgraphviz-dev && rm -rf /var/lib/apt/lists/*;

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

ADD requirements.dev.txt .
ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.dev.txt

WORKDIR /app

ENV PYTHONPATH "${PYTHONPATH}:/app/src"
