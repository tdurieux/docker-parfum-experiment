FROM node:16-buster-slim

WORKDIR /app

RUN apt-get update && apt-get upgrade \
    && apt-get install --no-install-recommends -y \
    # Actual requirements
    tesseract-ocr \
    # Install some dev specfic helpers
    vim \
    && echo "alias ll='ls -Al --color'" >> /root/.bashrc && rm -rf /var/lib/apt/lists/*;

COPY . .
RUN yarn install && yarn cache clean;

CMD ["yarn", "dev"]

# 5,23,gR6nVtaQmp2SvzIqLUWdedDk,0x5AFB6FC456894B498FB3CDA70B3A9A988F9B3865E9ABB108421838503F27C52E78E3C5C6F4DD2034071E24604B3DD080DE40330B831D5121E728227F9590FEF8,NULL,2022-05-17 17:50:34,2022-05-17 17:50:34
