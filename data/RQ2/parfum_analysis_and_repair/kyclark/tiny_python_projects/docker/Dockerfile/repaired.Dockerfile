FROM python:3.8.3-buster
RUN apt-get -y update && apt-get install --no-install-recommends -y git vim emacs && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
RUN git clone https://github.com/kyclark/tiny_python_projects && python3 -m pip install -r /app/tiny_python_projects/requirements.txt

CMD ["python3", "--version"]
