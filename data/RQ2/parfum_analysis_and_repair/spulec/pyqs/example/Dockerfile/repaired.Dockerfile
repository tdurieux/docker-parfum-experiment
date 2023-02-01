FROM python:3.6-slim-stretch

# install supervisord
RUN apt-get update \
&& apt-get install --no-install-recommends -y supervisor libcurl4-openssl-dev gcc libssl-dev libffi-dev python3-dev curl \
&& apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY . /api
WORKDIR /api

# install requirements
RUN pip install --no-cache-dir -r requirements.txt

# expose the app port
EXPOSE 8000

ENV PYTHONPATH="$PYTHONPATH:/api"

# run supervisord
CMD ["/usr/bin/supervisord"]
