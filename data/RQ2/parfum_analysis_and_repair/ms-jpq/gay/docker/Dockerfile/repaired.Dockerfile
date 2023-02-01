FROM python:latest


COPY . /
RUN pip install --no-cache-dir git+https://github.com/ms-jpq/gay.git
RUN gay < ./gay
RUN gay --help | ./demo.sh
RUN printf '' | ./demo.sh
RUN ./demo.sh < /dev/null
