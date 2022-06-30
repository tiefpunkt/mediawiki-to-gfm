FROM pandoc/latex
WORKDIR /src
COPY composer.* ./

# Install composer, refer: https://github.com/geshan/docker-php-composer-alpine/blob/master/Dockerfile
RUN apk --update add wget \
             curl \
             git \
             php8 \
             php8-curl \
             php8-openssl \
             php8-iconv \
             php8-json \
             php8-mbstring \
             php8-phar \
             php8-xml \
             php8-simplexml \
             php8-xmlwriter \
             php8-tokenizer \
             php8-dom --repository http://nl.alpinelinux.org/alpine/edge/testing/ && rm /var/cache/apk/* && \
             ln -s /usr/bin/php8 /usr/bin/php

#RUN curl -sS https://getcomposer.org/installer | php7 -- --install-dir=/usr/bin --filename=composer
RUN php8 -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php8 -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php8 composer-setup.php --install-dir=/usr/bin --filename=composer && \
    php8 -r "unlink('composer-setup.php');"
# end of install composer

RUN composer install
COPY . .
ENTRYPOINT ["/bin/sh"]
