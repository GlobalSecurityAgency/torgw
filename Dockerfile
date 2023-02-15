FROM alpine:edge

ENV PACKAGES=" \
	runit \
	haproxy \
	tor avahi bash dbus avahi-tools socat curl  \
	
"

RUN echo \
	&& apk update \
	&& apk add $PACKAGES \
	&& rm -rf /tmp/* /var/cache/apk/*  && mkdir /etc/CONFIG

ADD make-services.sh /haproxy.cfg /etc/CONFIG/
RUN bash -c "ln -sf /etc/CONFIG/haproxy.cfg /etc/haproxy/haproxy.cfg ;cd /dev/shm/ && bash /etc/CONFIG/make-services.sh && mv services /etc/sv "

ADD ./haproxy.cfg /etc/haproxy/haproxy.cfg
ADD ./entrypoint.sh /
#ADD services /etc/sv

EXPOSE 9050

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
