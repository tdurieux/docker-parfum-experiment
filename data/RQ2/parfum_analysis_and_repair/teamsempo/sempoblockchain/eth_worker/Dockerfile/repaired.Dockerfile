FROM python:3.8-slim-buster

RUN apt update && apt -y --no-install-recommends install gcc libssl-dev libffi-dev git-all curl: && rm -rf /var/lib/apt/lists/*;

COPY ./eth_worker/requirements.txt /
COPY ./test_requirements.txt /

RUN cd / && pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir -r test_requirements.txt

RUN pip install --no-cache-dir git+https://github.com/teamsempo/eth-account.git@celo

COPY ./eth_worker /

COPY ./config.py /
RUN mkdir /config_files
COPY ./config_files/* /config_files/

WORKDIR /

EXPOSE 80

RUN chmod +x /_docker_worker_script.sh

CMD ["/_docker_worker_script.sh"]