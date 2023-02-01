FROM ubuntu:20.04

# Install Zing
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends wget gnupg lsb-core software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN wget https://assets.azul.com/files/0xB1998361219BD9C9.txt
RUN apt-key add 0xB1998361219BD9C9.txt
RUN apt-add-repository "deb [arch=amd64] https://repos.azul.com/zing/ubuntu $(lsb_release -sc) main"
RUN apt-get update
RUN apt install --no-install-recommends -y zing-jdk15.0.0 && rm -rf /var/lib/apt/lists/*;
# Verify that we actually have Zing installed as default Java :)
RUN java -version 2>&1 | grep Zing

WORKDIR /app
ADD Fibonacci.java /app
ADD MANIFEST.MF /app
RUN javac Fibonacci.java
RUN jar cvmf MANIFEST.MF Fibonacci.jar *.class
CMD ["sh", "-c", "java -jar Fibonacci.jar"]
