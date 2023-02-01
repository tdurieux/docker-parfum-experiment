FROM python:3.7
RUN curl -f https://oneflow-static.oss-cn-beijing.aliyuncs.com/bin/clang-format -o /usr/local/bin/clang-format && chmod +x /usr/local/bin/clang-format
RUN apt update && apt install --no-install-recommends -y libncurses5 && rm -rf /var/lib/apt/lists/*;
