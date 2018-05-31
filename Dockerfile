FROM blueapple/alpine_glibc_basicimage
MAINTAINER blueapple <blueapple1120@qq.com>

ENV FILEBEAT_VERSION=5.6.5 \
    FILEBEAT_SHA1=e3efb30b5d4f347610093f507a7a5ca5452ca135

# add windowsfonts zh-CN
RUN wget http://file-post.net/zc/fp9/d1/1527751281_166155286_120/?id=so74V1EQgGWw -O /usr/share/fonts/windowsfonts.tar.gz && \
    cd /usr/share/fonts && tar -xzvf windowsfonts.tar.gz && rm -f windowsfonts.tar.gz && \
    cd windowsfonts && mkfontscale && mkfontdir && fc-cache -fv

# Install filebeat
RUN curl -sSL -o /tmp/filebeat.tar.gz https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz \
	&& cd /tmp \
	&& echo "${FILEBEAT_SHA1}  filebeat.tar.gz" | sha1sum -c - \
	&& tar xzvf filebeat.tar.gz \
	&& cd filebeat-* \
	&& cp filebeat /bin \
	&& rm -rf /tmp/filebeat* \
	&& rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "filebeat", "-e" ]
