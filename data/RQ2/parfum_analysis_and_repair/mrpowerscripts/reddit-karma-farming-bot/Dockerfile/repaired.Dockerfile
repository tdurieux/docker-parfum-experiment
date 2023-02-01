FROM python:3.8

COPY . /app
WORKDIR /app
RUN apt update && apt install --no-install-recommends -yqq g++ gcc libc6-dev make pkg-config libffi-dev python3-dev git && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pipenv
RUN pipenv install --system --deploy --ignore-pipfile
RUN chmod +x /app/run_linux.sh
ENTRYPOINT /app/run_linux.sh


