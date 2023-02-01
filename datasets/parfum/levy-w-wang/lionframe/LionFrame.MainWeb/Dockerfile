FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base

WORKDIR /lionframe
COPY . /lionframe

# �ļ���docs�У����������������ͼƬ�ٶ�
# �������� https://mirrors.163.com/.help/debian.html
RUN cp sources.list /etc/apt/ 

RUN apt-get update && apt-get install -y libgdiplus

EXPOSE 5000

# ����ʱ��
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENTRYPOINT ["dotnet", "LionFrame.MainWeb.dll"]