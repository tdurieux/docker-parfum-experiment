FROM python:3.5

RUN apt-get update -y && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

WORKDIR /code
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r /code/requirements.txt

WORKDIR /code
COPY . .

COPY app.conf /etc/nginx/sites-enabled/default
COPY run.sh /
CMD ["/run.sh"]
