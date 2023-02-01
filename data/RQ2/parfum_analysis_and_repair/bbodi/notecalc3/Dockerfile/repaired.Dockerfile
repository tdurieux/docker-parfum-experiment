FROM rnsloan/wasm-pack

RUN apt update && apt install --no-install-recommends -y nodejs npm && rm -rf /var/lib/apt/lists/*;
RUN npm install -g serve && npm cache clean --force;

EXPOSE 5000/tcp
EXPOSE 5000/udp

RUN git clone https://github.com/bbodi/notecalc3.git .
RUN chmod +x compile_and_run.bat

CMD ./compile_and_run.bat
