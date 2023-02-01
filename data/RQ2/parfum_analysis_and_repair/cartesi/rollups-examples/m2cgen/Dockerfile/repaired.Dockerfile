FROM python:3.8.10 as model

WORKDIR /usr/src/app
COPY ./model .
RUN pip3 install --no-cache-dir -r requirements.txt
RUN python3 build_model.py

FROM cartesi/toolchain:0.10.0 as dapp-build

WORKDIR /opt/cartesi/dapp
COPY . .
COPY --from=model /usr/src/app/model.py .
