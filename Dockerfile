FROM nginx:latest
MAINTAINER Ruzhentsev Alexandr noc@mirafox.ru

RUN echo deb http://httpredir.debian.org/debian jessie-backports main | tee /etc/apt/sources.list.d/backports.list \
    && apt-get update && apt-get -y upgrade \
    && apt-get install -y ssl-cert supervisor nginx \
    && apt-get install -y python-certbot-nginx -t jessie-backports \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

COPY config/nginx.conf 			/etc/nginx/nginx.conf
COPY config/nginx-vhost.conf 		/etc/nginx/conf.d/default.conf
COPY config/nginx-vhost-ssl.conf 	/etc/nginx/conf.d/default-ssl.conf
COPY config/supervisord.conf 		/etc/supervisord.conf
COPY scripts/ 				/usr/local/bin/

RUN chmod 755 /usr/local/bin/letsencrypt-init \
    && chmod 755 /usr/local/bin/letsencrypt-renew \
    && chmod 755 /usr/local/bin/docker-entrypoint.sh

VOLUME /var/www/html

EXPOSE 80 443

CMD ["/usr/local/bin/docker-entrypoint.sh"]
