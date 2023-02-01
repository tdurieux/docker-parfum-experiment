FROM phusion/baseimage

RUN apt-get update
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 python-pip python3-dev libpq-dev postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*;

ADD ./ /app/

WORKDIR /app/

RUN pip install --no-cache-dir -r requirements.txt
