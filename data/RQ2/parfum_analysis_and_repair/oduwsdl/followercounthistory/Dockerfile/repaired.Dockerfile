FROM       python:3
LABEL      maintainer="Mohammed Nauman Siddique <@m_nsiddique>"

RUN apt update && apt install --no-install-recommends -y r-base && rm -rf /var/lib/apt/lists/*

WORKDIR    /app
COPY       requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY 	   twitterFollowerCount.R ./
COPY       fch/ ./fch
COPY       tests/ ./tests

ENTRYPOINT ["./fch/__main__.py"]
