FROM python:latest

RUN pip3 install --no-cache-dir --user https://releases.ansible.com/ansible-tower/cli/ansible-tower-cli-latest.tar.gz

ENV PATH="/root/.local/bin:${PATH}"

CMD [ "awx", "--help" ]
