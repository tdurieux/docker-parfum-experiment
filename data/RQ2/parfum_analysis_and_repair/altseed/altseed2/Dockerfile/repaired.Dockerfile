FROM python:3

RUN apt-get update && apt install --no-install-recommends -y clang clang-format && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade setuptools

WORKDIR /home/src

COPY . /home/src
RUN pip install --no-cache-dir -r scripts/requirements.txt

EXPOSE 3000

