FROM python:3.7

WORKDIR /app

ENV PYTHONUNBUFFERED=1

COPY requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r requirements.txt || true
# этого добра просто нет в requirements.txt и оно там не появляется
RUN pip install --no-cache-dir py_ecc
# доустанавливаем зависимости, игнорируя конфликты версий
RUN pip install --no-cache-dir -r requirements.txt --no-deps || true

# ставим зависимость для работы airdrop-contract (./contracts/airdrop-contract)
RUN pip install --no-cache-dir git+https://chromium.googlesource.com/external/gyp

# устанавливаем модуль near из нашего репозитория
RUN pip install --no-cache-dir git+https://github.com/MyWishPlatform/near-api-py.git@master

RUN wget https://github.com/eosio/eos/releases/download/v2.1.0/eosio_2.1.0-1-ubuntu-20.04_amd64.deb

RUN apt update

RUN apt -y --no-install-recommends install ./eosio_2.1.0-1-ubuntu-20.04_amd64.deb && rm -rf /var/lib/apt/lists/*;

# npm для установки тулзы командной строки для near
RUN apt -y --no-install-recommends install npm && rm -rf /var/lib/apt/lists/*;

RUN npm install -g near-cli && npm cache clean --force;

COPY . /app
