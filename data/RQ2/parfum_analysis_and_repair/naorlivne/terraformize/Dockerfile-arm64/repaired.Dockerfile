# first need to get the terrafrom binary and extract it
FROM python:3.10.0b2-alpine3.12 AS terraform_installer
ADD https://releases.hashicorp.com/terraform/1.1.9/terraform_1.1.9_linux_arm64.zip /tmp/
RUN unzip /tmp/terraform_*.zip -d /tmp

# it's offical so i'm using it + alpine so damn small
FROM python:3.10.0b2-alpine3.12

#exposing the port
EXPOSE 80

# set python to be unbuffered
ENV PYTHONUNBUFFERED=1

# set terraform automation flag
ENV TF_IN_AUTOMATION=true

# install required packages
RUN apk add --no-cache libffi-dev

# copy terraform binary and make it executable
COPY --from=terraform_installer /tmp/terraform /usr/local/bin/terraform
RUN chmod +x /usr/local/bin/terraform

# adding the gunicorn config
COPY config/config.py /etc/gunicorn/config.py

COPY requirements.txt /www/requirements.txt
RUN pip install --no-cache-dir -r /www/requirements.txt

# copy the codebase
COPY . /www
RUN chmod +x /www/terraformize_runner.py

# and running it
CMD ["gunicorn" ,"--config", "/etc/gunicorn/config.py", "terraformize_runner:app"]
