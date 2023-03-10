FROM onap/integration-java11:7.0.0
MAINTAINER mc4615@att.com
EXPOSE 8080
ENV APP_HOME /home/$USER_NAME/app
RUN mkdir $APP_HOME
ADD mso-openstack-adapters-1.1.0-SNAPSHOT.jar $APP_HOME/mso-openstack-adapters-1.1.0-SNAPSHOT.jar
WORKDIR $APP_HOME
RUN touch mso-openstack-adapters-1.1.0-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","-Dspring.profiles.active=dev","mso-openstack-adapters-1.1.0-SNAPSHOT.jar"]






######### README #########
# NOTES ########
# cd /Users/mercychan/git/mso-e/adapters/mso-openstack-adapters/Deployment/
# docker build -f Dockerfile.adapters -t mercechan/msoadapters .
# docker run -it -p 8080:8080 --name mchan mercechan/msoadapters # interactive mode
# docker run -d -p 8080:8080 --name mchan mercechan/msoadapters # daemon mode
# docker exec -it mchan /bin/bash # this will get you in docker container
# NOTES ########


# COMMANDS ########
# 1. CREATE MSO_NETWORK TO HOST CONTAINER
# docker network ls # show list of existing networks
# docker network create --driver bridge mso_network
# docker network inspect mso_network  # this will list details of the named network
# docker network rm mso_network # remove mso_network docker network, optional
# docker logs mchan # to show log info for mchan container

# 2. CREATE CONTAINER AND PUT IT IN THE MSO_NETWORK
# FOR DAEMON MODE USE -d
# docker run -d --net=mso_network -p 8080:8080 --name mchan mercechan/msoadapters
# OR for interactive mode (-it), run the following command
# docker run -it --net=mso_network -p 8080:8080 --name mchan mercechan/msoadapters
# COMMANDS ########
######### README #########