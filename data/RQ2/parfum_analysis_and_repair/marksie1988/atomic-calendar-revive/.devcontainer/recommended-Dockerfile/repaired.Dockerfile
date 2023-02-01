FROM node:latest

RUN apt update && apt install --no-install-recommends python3 zsh -y && rm -rf /var/lib/apt/lists/*;
RUN apt upgrade  -y



RUN wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | zsh || true

RUN yarn install && yarn cache clean;

RUN pip3 install --no-cache-dir -r ../docs/requirements.txt
RUN pip3 install --no-cache-dir sphinx

CMD ["zsh"]
