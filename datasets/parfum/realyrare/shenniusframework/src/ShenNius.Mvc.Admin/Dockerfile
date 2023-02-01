
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 8816  #�˿ںţ������� 5000 �˿ڱ�¶������ �����ⲿ��������˿ڡ���
COPY . . #����ǰĿ¼�µ������ļ�������.dockerignore�ų���·���������������� image �ļ���/appĿ¼
ENTRYPOINT ["dotnet", "ShenNius.Mvc.Admin.dll"] #���еĳ���