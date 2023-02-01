FROM python:3.8

WORKDIR /opt/cassh

COPY requirements.txt ./

RUN pip install --no-cache-dir -U pip

RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && apt-get install --no-install-recommends -y ssl-cert && rm -rf /var/lib/apt/lists/*;

COPY . .

CMD [ "python", "./cassh_web.py" ]
