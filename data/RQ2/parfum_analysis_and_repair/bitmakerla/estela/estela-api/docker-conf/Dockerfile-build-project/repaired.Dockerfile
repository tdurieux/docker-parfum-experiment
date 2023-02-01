FROM python:3.6

WORKDIR /home/estela

COPY estela-api/requirements ./requirements

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update

RUN apt-get install --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --batch --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  focal stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update

RUN apt-get install --no-install-recommends docker-ce docker-ce-cli containerd.io -y && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -r requirements/deploy.txt

COPY estela-api/ estela-api/
COPY database_adapters/ estela-api/database_adapters/
