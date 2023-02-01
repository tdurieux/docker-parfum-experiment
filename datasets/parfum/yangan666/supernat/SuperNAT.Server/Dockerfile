#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM registry.cn-hangzhou.aliyuncs.com/newbe36524/runtime-deps:5.0

FROM registry.cn-hangzhou.aliyuncs.com/newbe36524/aspnet:5.0

#������Ŀpublish�ļ����е������ļ��� docker�����е�publish�ļ����� , publish �����и�������

COPY . /supernat/server

#���ù���Ŀ¼Ϊ `/publish` �ļ��У�����������Ĭ�ϵ��ļ���

WORKDIR /supernat/server

#����Docker�������Ⱪ¶8088�˿ڣ�����ǽ��Ҫ���Ŵ˶˿ڣ������ dotnet xx.dll����ʱ�Ķ˿ڱ���һ��

EXPOSE 8088

#ʹ��`dotnet xx.dll`������Ӧ�ó���
ENTRYPOINT ["dotnet", "SuperNAT.Server.dll"]