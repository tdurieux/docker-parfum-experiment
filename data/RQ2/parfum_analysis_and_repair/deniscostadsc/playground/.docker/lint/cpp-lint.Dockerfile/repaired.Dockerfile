FROM python:3

RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir cpplint
RUN apt update && apt install --no-install-recommends clang-format -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir /code
WORKDIR /code
