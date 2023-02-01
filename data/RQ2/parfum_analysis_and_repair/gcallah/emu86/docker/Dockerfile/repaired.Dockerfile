FROM python:3.6.0

ENV PROJECT Emu86

COPY requirements.txt /requirements.txt
COPY requirements-dev.txt /requirements-dev.txt

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir -r requirements-dev.txt

WORKDIR /home/$PROJECT/

RUN apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
