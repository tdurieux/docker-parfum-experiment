FROM ubuntu:16.04

COPY ./publish /wwwroot

WORKDIR /wwwroot

EXPOSE 8800

RUN sed -i 's/archive.ubuntu.com/cn.archive.ubuntu.com/g' /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends libgdiplus libunwind8 openssl -y && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/lib/libgdiplus.so /usr/lib/gdiplus.dll

CMD [ "./ZKWeb.MVVMDemo.AspNetCore", "--server.urls", "http://*:8800" ]
