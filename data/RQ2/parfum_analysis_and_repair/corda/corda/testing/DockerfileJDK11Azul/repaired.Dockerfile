FROM stefanotestingcr.azurecr.io/buildbase:11latest
COPY . /tmp/source
CMD cd /tmp/source && GRADLE_USER_HOME=/tmp/gradle ./gradlew clean testClasses integrationTestClasses --parallel --info