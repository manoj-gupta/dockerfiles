FROM aarch64/debian

USER root

RUN apt-get update && \
    apt-get install -qy curl unzip build-essential

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
    apt-get install -y nodejs

WORKDIR /var/www/
RUN mkdir -p ghost

# Download Ghost
RUN curl -L https://github.com/TryGhost/Ghost/releases/download/0.11.8/Ghost-0.11.8.zip -o ghost.zip && \
    unzip -uo ghost.zip -d ghost && rm ./*.zip

RUN npm install -g pm2

WORKDIR /var/www/ghost
RUN npm install sqlite3
RUN npm install

EXPOSE 2368
EXPOSE 2369
RUN ls && pwd

ENV NODE_ENV production

RUN sed -e s/127.0.0.1/0.0.0.0/g ./config.example.js > ./config.js

VOLUME ["/var/www/ghost/content/apps"]
VOLUME ["/var/www/ghost/content/data"]
VOLUME ["/var/www/ghost/content/images"]

CMD ["pm2", "start", "index.js", "--name", "blog", "--no-daemon"]
