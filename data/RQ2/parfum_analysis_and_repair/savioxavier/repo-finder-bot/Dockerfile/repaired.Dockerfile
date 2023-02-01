FROM python:3.9.6

RUN pip install --no-cache-dir -U \
    pip \
    setuptools \
    wheel

WORKDIR /repo-finder-bot

RUN useradd -m -r user && \
    chown user /repo-finder-bot

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

USER user

ENTRYPOINT ["/usr/local/bin/python3", "main.py"]
