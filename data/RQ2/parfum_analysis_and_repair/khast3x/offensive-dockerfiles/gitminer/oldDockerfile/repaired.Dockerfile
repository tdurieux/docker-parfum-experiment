FROM python:3-slim

#RUN apk add --update git python-dev g++ gcc libxslt-dev

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/UnkL4b/GitMiner.git
WORKDIR GitMiner/
RUN pip install --no-cache-dir -r requirements.txt


ENTRYPOINT ["python", "git_miner.py"]
CMD ["-h"]