FROM python:2

WORKDIR /usr/src/hdlConvetor
COPY . ./

RUN apt update && apt install --no-install-recommends -y cmake ninja-build libantlr4-runtime-dev antlr4 && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir git+https://github.com/Nic30/hdlConvertorAst.git
RUN pip install --no-cache-dir -e .

#CMD ["python", "-m", "tests.all"]
