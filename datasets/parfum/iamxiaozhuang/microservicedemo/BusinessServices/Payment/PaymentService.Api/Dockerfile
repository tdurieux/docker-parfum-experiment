FROM microsoft/dotnet:2.2-aspnetcore-runtime
WORKDIR /app
COPY . .
EXPOSE 80
ENTRYPOINT ["dotnet", "PaymentService.Api.dll"]