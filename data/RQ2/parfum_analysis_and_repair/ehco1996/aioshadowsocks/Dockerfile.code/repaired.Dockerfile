FROM ehco1996/aioshadowsocks:runtime as runtime

COPY --from=pyroscope/pyroscope:latest /usr/bin/pyroscope /usr/bin/pyroscope

LABEL Name="aio-shadowsocks" Maintainer="Ehco1996"

WORKDIR /src/aioshadowsocks

COPY . /src/aioshadowsocks

CMD ["python", "-m", "shadowsocks", "run_ss_server"]