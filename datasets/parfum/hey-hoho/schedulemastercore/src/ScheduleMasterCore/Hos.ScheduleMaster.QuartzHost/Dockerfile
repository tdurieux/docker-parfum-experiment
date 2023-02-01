
# ���ӻ�������
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1

#������ϵͳ�Ĺ����ռ�
WORKDIR /app

#������ǰ�ļ����µ��ļ���������ϵͳ�Ĺ����ռ�
COPY . /app
 
#����Docker�������Ⱪ¶�Ķ˿�
EXPOSE 80 5000

#����Ĭ��ʱ��
ENV TZ="Asia/Shanghai"

#�Զ��������в���
#ENV MS_OPTS ""

#������ʹ�� ["dotnet","ϵͳ������dll"] ������Ӧ�ó���
ENTRYPOINT ["dotnet","Hos.ScheduleMaster.QuartzHost.dll"]

#ENTRYPOINT dotnet Hos.ScheduleMaster.QuartzHost.dll  $MS_OPTS
