
# ���ӻ�������
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1

#������ϵͳ�Ĺ����ռ�
WORKDIR /app

#������ǰ�ļ����µ��ļ���������ϵͳ�Ĺ����ռ�
COPY . /app
 
#����Docker�������Ⱪ¶�Ķ˿�
EXPOSE 30000

#����Ĭ��ʱ��
ENV TZ="Asia/Shanghai"

#������ʹ�� ["dotnet","ϵͳ������dll"] ������Ӧ�ó���
ENTRYPOINT ["dotnet", "Hos.ScheduleMaster.Web.dll"]