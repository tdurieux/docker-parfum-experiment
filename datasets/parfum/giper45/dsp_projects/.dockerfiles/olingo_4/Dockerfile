FROM mcneilco/tomcat-maven
RUN wget https://www.exploit-db.com/apps/957be84cad64ad80be98bb00ebe162aa-Olingo-OData-4.6.0-source-release.zip
RUN yum update -y && yum install -y unzip
RUN unzip -q 957be84cad64ad80be98bb00ebe162aa-Olingo-OData-4.6.0-source-release.zip
WORKDIR Olingo-OData-4.6.0
RUN mvn -Dhttps.protocols=TLSv1.2 clean install
CMD /bin/bash