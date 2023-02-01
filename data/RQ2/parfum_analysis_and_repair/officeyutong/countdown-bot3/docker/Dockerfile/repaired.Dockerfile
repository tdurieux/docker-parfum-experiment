FROM python

RUN pip3 install --no-cache-dir pip -U
RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip3 install --no-cache-dir numpy sympy scipy matplotlib

COPY sources.list /etc/apt/
RUN apt update
RUN apt install --no-install-recommends gcc g++ -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends dvipng -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends texlive-full -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pillow
RUN apt install --no-install-recommends ghc -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends rustc -y && rm -rf /var/lib/apt/lists/*;
COPY check.py /
RUN python /check.py