FROM python:2.7

MAINTAINER Angelo Moura "m4n3dw0lf@gmail.com"

WORKDIR /helix

COPY . .

RUN curl -f -sSL https://get.docker.com | sh

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python","run.py"]
