FROM swift:5.1

EXPOSE 8080
USER root

# Install dependencies
RUN apt-get update && apt-get install -y libhttp-parser-dev libcurl4-openssl-dev openssl libssl-dev libz-dev libcairo2-dev curl unzip fontconfig

# Install font
RUN mkdir -p /usr/share/fonts && cd /usr/share/fonts && curl "https://fonts.google.com/download?family=Rubik" > Rubik.zip && unzip Rubik.zip && rm -f Rubik.zip && fc-cache -fv

# Copy code
COPY . /var/www/contrast/

# Compile code
RUN cd /var/www/contrast && swift build -c release -Xcc -fblocks -Xswiftc -I/usr/local/include -Xlinker -L/usr/local/lib

# Provide entrypoint to built binary
ENTRYPOINT "/var/www/contrast/.build/release/ContrastWeb"
