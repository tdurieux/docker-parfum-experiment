FROM python:3.7
WORKDIR /{{cookiecutter.python_slug}}/
ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ADD . .
RUN pip install --no-cache-dir .

EXPOSE {{cookiecutter.api_port}}

CMD start_api_server
