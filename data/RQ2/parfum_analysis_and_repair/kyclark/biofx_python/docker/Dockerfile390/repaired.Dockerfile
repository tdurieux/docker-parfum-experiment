FROM python:3.9.0-buster
RUN apt-get -y update && apt-get install --no-install-recommends -y git vim emacs && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
ARG BAR=foo
RUN git clone https://github.com/kyclark/biofx_python && python3 -m pip install -r /app/biofx_python/requirements.txt

RUN cp /app/biofx_python/mypy.ini ~/.mypy.ini
RUN cp /app/biofx_python/pylintrc ~/.pylintrc

CMD ["python3", "--version"]
