FROM thespaghettidetective/web:base-1.8

WORKDIR /app
EXPOSE 3334

ADD . /app
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -r requirements.txt
