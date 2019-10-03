FROM swift:5.1

EXPOSE 8080

USER root

RUN apt-get update && apt-get install -y libhttp-parser-dev libcurl4-openssl-dev openssl libssl-dev libz-dev

COPY . /var/www/contrast/

RUN cd /var/www/contrast && swift build -c release -Xcc -fblocks -Xswiftc -I/usr/local/include -Xlinker -L/usr/local/lib
CMD ["/var/www/contrast/.build/release/ContrastWeb"]
