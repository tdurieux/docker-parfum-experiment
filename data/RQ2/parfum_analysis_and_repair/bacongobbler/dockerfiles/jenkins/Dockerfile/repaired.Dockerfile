from        ubuntu
maintainer  Matthew Fisher <me@bacongobbler.com>

run apt-get update && apt-get install --no-install-recommends -q -y openjdk-6-jre-headless && rm -rf /var/lib/apt/lists/*;
add         http://mirrors.jenkins-ci.org/war/1.553/jenkins.war jenkins.war

expose      8080

cmd         ["java", "-jar", "jenkins.war"]
