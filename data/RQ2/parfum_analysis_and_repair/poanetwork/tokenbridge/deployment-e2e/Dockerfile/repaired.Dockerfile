FROM python:3.7-stretch
RUN curl -fsSL https://get.docker.com | sh
RUN pip3 install --no-cache-dir docker molecule==2.22rc1 molecule[docker] flake8
WORKDIR mono/deployment-e2e
