FROM microsoft/dotnet:2.1.1-aspnetcore-runtime 

#���ù���Ŀ¼
WORKDIR /app

#���Ʒ����ļ���/app��
COPY . /app

#���ö˿�
EXPOSE 4044

#ʹ��dotnet LisAPI.dll������asp.net core��Ŀ��ע���Сд
ENTRYPOINT ["dotnet", "K8SASPNETCOREDemo002.dll"]
