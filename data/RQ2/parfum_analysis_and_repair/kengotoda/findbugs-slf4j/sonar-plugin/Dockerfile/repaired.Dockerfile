# After `mvn clean package` in the project root dir, run following command to build:
# docker image build . -t findbugs-slf4j
#
# Then you can run SonarQube instance with findbugs-slf4j:
# docker container run -it -P findbugs-slf4j