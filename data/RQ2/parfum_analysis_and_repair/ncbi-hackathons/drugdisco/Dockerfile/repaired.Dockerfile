FROM python:latest

RUN mkdir /DrugDisco
COPY . /DrugDisco
WORKDIR /DrugDisco

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt

