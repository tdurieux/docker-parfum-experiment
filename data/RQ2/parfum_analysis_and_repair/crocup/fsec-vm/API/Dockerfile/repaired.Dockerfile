FROM python:3.9
MAINTAINER info@fsec.com
RUN apt-get update && apt-get install --no-install-recommends -y nmap && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
# install app
WORKDIR /api
COPY ./requirements.txt /api/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /api/requirements.txt
RUN pip install --no-cache-dir "uvicorn[standard]"
COPY ./app /api/app
WORKDIR /api/app
CMD ["uvicorn", "--host", "0.0.0.0", "main:app"]
