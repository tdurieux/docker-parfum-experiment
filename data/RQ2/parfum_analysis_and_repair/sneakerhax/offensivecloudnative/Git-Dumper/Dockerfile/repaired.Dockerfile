# A dockerized version of the tool git-dumper by arthaud

FROM python:3

RUN apt update && apt upgrade -y && apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/arthaud/git-dumper
WORKDIR /git-dumper
RUN pip3 install --no-cache-dir -r requirements.txt


ENTRYPOINT ["python", "git_dumper.py"]