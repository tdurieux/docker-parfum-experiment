FROM node:16.12.0-buster

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ADD . /
ENV PATH="/root/.cargo/bin:${PATH}"
RUN make install-rust-deps
RUN yarn install
RUN yarn build
