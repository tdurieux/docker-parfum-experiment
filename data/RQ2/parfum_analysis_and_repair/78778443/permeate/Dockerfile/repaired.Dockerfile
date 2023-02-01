#FROM daxia/qingscan:ub20
FROM daxia/websafe:latest

# 基础内容更新
ENV DEBIAN_FRONTEND=noninteractive
ADD  script.py /root/
RUN apt update -y && apt install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;


# 定义端口为80
EXPOSE 80
CMD ["python3", "/root/script.py"]
#   docker build -t daxia/websafe:v1.0 .