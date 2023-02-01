FROM python:3.7.1

RUN apt-get update && apt-get install --no-install-recommends -y cmake bison flex && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/app

ENV PYTHONPATH=/usr/src/app/

EXPOSE 80

CMD [ "python", "app.py" ]
