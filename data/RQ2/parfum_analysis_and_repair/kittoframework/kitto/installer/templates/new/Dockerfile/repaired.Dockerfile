FROM zorbash/kitto

ENV MIX_ENV prod

RUN mkdir /dashboard
WORKDIR /dashboard

ADD ./mix.exs ./
ADD ./mix.lock ./
RUN mix deps.get

ADD ./package.json ./
RUN npm install --silent && npm cache clean --force;

ADD . /dashboard
RUN npm run build
RUN mix compile

CMD mix kitto.server
