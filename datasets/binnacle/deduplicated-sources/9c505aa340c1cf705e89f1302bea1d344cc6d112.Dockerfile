FROM openjdk:latest  
  
RUN apt-get install -y curl \  
&& curl -sL https://deb.nodesource.com/setup_6.x | bash - \  
&& apt-get install -y nodejs \  
&& curl -L https://www.npmjs.com/install.sh | sh \  

