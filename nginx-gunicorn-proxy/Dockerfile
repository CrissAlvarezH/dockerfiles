FROM nginx:1.25.3-alpine3.18

COPY ./nginx.template.conf /etc/nginx/nginx.template.conf
COPY ./run.sh /run.sh

USER root

# create static folder
RUN mkdir -p /vol/static && \
    chmod 755 /vol/static

# create files and add permission to nginx user
RUN touch /run/nginx.pid && \
    chown nginx:nginx /run/nginx.pid && \
    touch /etc/nginx/nginx.conf && \
    chown nginx:nginx /etc/nginx/nginx.conf && \
    chown -R nginx:nginx /var/cache/nginx

RUN chmod +x /run.sh

VOLUME /vol/static

USER nginx

EXPOSE $LISTEN_PORT

CMD ["/run.sh"]
