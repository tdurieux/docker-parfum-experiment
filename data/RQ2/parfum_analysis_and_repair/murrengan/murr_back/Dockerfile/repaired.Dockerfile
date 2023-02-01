FROM python:3.7-slim
WORKDIR /home/murrengan

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --no-cache-dir --upgrade pip

COPY requirements.txt /home/murrengan/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir gunicorn

RUN apt-get update && apt-get install --no-install-recommends netcat -y && rm -rf /var/lib/apt/lists/*;

COPY . /home/murrengan

ENTRYPOINT ["/home/murrengan/entrypoint.sh"]
