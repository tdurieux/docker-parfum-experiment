FROM healthopenshift/hg-base:latest
COPY . .
EXPOSE 8080
ENTRYPOINT ["dotnet","Medication.dll"]