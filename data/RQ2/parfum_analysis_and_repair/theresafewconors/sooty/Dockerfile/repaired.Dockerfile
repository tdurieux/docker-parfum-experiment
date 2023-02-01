FROM python:3.7-slim-buster
RUN apt-get update
RUN apt-get install --no-install-recommends g++ tk -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir /app
WORKDIR /app
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app/
RUN apt-get install --no-install-recommends curl -y \
    && curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin && rm -rf /var/lib/apt/lists/*;
CMD [ "python3" ,"/app/Sooty.py" ]