#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM registry.cn-hangzhou.aliyuncs.com/newbe36524/runtime-deps:5.0

FROM registry.cn-hangzhou.aliyuncs.com/newbe36524/aspnet:5.0

#������Ŀpublish�ļ����е������ļ��� docker�����е�publish�ļ����� , publish �����и�������

COPY . /supernat/client

#���ù���Ŀ¼Ϊ `/publish` �ļ��У�����������Ĭ�ϵ��ļ���

WORKDIR /supernat/client

#ʹ��`dotnet xx.dll`������Ӧ�ó���
ENTRYPOINT ["dotnet", "SuperNAT.Client.dll"]