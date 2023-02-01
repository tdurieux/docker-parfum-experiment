FROM python:latest

RUN apt update
RUN apt install --no-install-recommends --yes git && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends --yes emacs && rm -rf /var/lib/apt/lists/*;

# Installing python-pip is optional.
# The python image already has it.

RUN apt install --no-install-recommends --yes python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir tensorflow
RUN pip install --no-cache-dir matplotlib

RUN mkdir -p /home/turner

WORKDIR /home/turner

CMD ["bash"]
