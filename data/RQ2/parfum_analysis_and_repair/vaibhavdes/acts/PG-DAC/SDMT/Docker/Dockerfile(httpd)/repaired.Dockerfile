1. Create Dockerfile

FROM httpd:2.4
COPY ./myweb/ /usr/local/apache2/htdocs/

2. Create Directory myweb and put all web files

3. Build using Dockerfile

docker build -t myweb1 .

4. Run Image

docker run -idt -p 8080:80 myweb1

5. Visit 

localhost:8080