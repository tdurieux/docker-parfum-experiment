FROM python:3.9
MAINTAINER info@fsec.com
RUN apt-get update && apt-get install --no-install-recommends -y nmap && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
# install app
WORKDIR /Scanner
COPY ./requirements.txt /Scanner/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /Scanner/requirements.txt
COPY ./app /Scanner
CMD ["python", "main.py"]
