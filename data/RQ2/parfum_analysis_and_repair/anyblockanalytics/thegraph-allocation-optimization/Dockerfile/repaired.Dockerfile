FROM python:3.8-bullseye
RUN apt update && apt-get install --no-install-recommends -y glpk-utils libglpk-dev glpk-doc python3-swiglpk && rm -rf /var/lib/apt/lists/*;

RUN mkdir /src
WORKDIR /src

COPY requirements.txt /src
RUN pip install --no-cache-dir -r requirements.txt

COPY . /src
COPY .env .env
#ENV RPC_URL https://api.anyblock.tools/ethereum/ethereum/mainnet/rpc/XXXX-XXXXX-XXXX/

ENTRYPOINT ["python","main.py"]
