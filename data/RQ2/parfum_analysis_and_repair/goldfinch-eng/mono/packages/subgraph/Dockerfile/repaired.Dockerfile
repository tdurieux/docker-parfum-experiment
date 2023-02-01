FROM ubuntu:20.04

ENV ARGS=""

RUN apt update
RUN apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y postgresql && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;

RUN curl -f -OL https://github.com/LimeChain/matchstick/releases/download/0.2.2/binary-linux-20
RUN chmod a+x binary-linux-20

RUN mkdir matchstick
WORKDIR matchstick

COPY ./ .

RUN rm -rf node_modules/

RUN npm install && npm cache clean --force;
RUN npm run codegen
RUN npm run build

CMD ../binary-linux-20 ${ARGS}
