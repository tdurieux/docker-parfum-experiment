FROM python:3.6.3-jessie

EXPOSE 80
EXPOSE 443

ENV HOME=/home/hot
WORKDIR $HOME

COPY ./ $HOME/ml-enabler
WORKDIR $HOME/ml-enabler
RUN \
  pip install --no-cache-dir gunicorn; \
  pip install --no-cache-dir -r requirements.txt

CMD gunicorn --bind 0.0.0.0:5000 --timeout 120 'ml_enabler:create_app()'
