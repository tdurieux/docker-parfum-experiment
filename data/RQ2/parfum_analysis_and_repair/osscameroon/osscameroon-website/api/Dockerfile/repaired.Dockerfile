FROM python:3.8-slim-buster

RUN apt update && apt install --no-install-recommends git gcc -y && rm -rf /var/lib/apt/lists/*;
ENV PYHTONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
ADD ./requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . /code

CMD [ "python", "manage.py", "run" ]
