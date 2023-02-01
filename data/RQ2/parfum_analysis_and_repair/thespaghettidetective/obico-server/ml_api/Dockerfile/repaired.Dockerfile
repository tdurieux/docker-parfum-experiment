FROM thespaghettidetective/ml_api:base-1.1
WORKDIR /app
EXPOSE 3333

ADD . /app
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

RUN wget --quiet -O model/model.weights $(cat model/model.weights.url | tr -d '\r')
