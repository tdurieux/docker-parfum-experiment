FROM ubuntu:16.04
MAINTAINER learnitdeep <learnitdeep@gmail.com>

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y python-pip default-jre default-jdk unzip wget git curl
RUN pip install pexpect simplejson bottle
RUN git clone https://github.com/zerobugplz/social-engineering-defense.git
WORKDIR /social-engineering-defense
RUN git clone https://gitlab.com/learnitdeep/scam-question-detector.git
RUN wget http://central.maven.org/maven2/com/google/code/gson/gson/2.8.0/gson-2.8.0.jar
RUN wget https://projects.csail.mit.edu/jwi/download.php?f=edu.mit.jwi_2.4.0.jar
RUN mv download.php\?f=edu.mit.jwi_2.4.0.jar edu.mit.jwi_2.4.0.jar
RUN wget https://nlp.stanford.edu/software/stanford-english-corenlp-2017-06-09-models.jar
RUN wget http://central.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar
RUN wget http://nlp.stanford.edu/software/stanford-corenlp-full-2017-06-09.zip
RUN unzip stanford-corenlp-full-2017-06-09.zip
RUN mv stanford-corenlp-full-2017-06-09 jar
RUN rm -rf stanford-corenlp-full-2017-06-09.zip
RUN mv edu.mit.jwi_2.4.0.jar jar
RUN mv gson-2.8.0.jar jar
RUN mv stanford-english-corenlp-2017-06-09-models.jar jar
RUN mv commons-lang-2.6.jar jar
RUN mv jar /social-engineering-defense/check_phishing_with_command
WORKDIR /social-engineering-defense/check_phishing_with_command
RUN javac -cp "./jar/*" DetectPhishingMail.java CoreNLP.java MakeBlacklist.java WordNet.java
WORKDIR /

