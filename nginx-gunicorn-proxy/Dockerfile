FROM nginxinc/nginx-unprivileged:1-alpine

COPY ./nginx.template.conf /etc/nginx/nginx.template.conf
COPY ./run.sh /run.sh

USER root

RUN mkdir -p /vol/static && \
    chmod 755 /vol/static && \
    touch /etc/nginx/nginx.conf && \
    chown nginx:nginx /etc/nginx/nginx.conf && \
    chmod +x /run.sh && \
    touch /run/nginx.pid && \
    chown -R nginx:nginx /run/nginx.pid

VOLUME /vol/static

USER nginx

EXPOSE $LISTEN_PORT

CMD ["/run.sh"]
