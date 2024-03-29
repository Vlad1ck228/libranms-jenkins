  LIBRENMS_DOCKER="1" \
  TZ="UTC" \
  PUID="1000" \
  PGID="1000"

RUN addgroup -g ${PGID} librenms \
  && adduser -D -h /home/librenms -u ${PUID} -G librenms -s /bin/sh -D librenms \
  && curl -sSLk -q https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro -o /usr/bin/distro \
  && chmod +x /usr/bin/distro

WORKDIR ${LIBRENMS_PATH}
ARG LIBRENMS_VERSION
ARG WEATHERMAP_PLUGIN_COMMIT
RUN apk --update --no-cache add -t build-dependencies \
    build-base \
    linux-headers \
    musl-dev \
    python3-dev \
  && echo "Installing LibreNMS https://github.com/librenms/librenms.git#${LIBRENMS_VERSION}..." \
  && git clone --depth=1 --branch ${LIBRENMS_VERSION} https://github.com/librenms/librenms.git . \
  && pip3 install --ignore-installed -r requirements.txt --upgrade --break-system-packages \
  && COMPOSER_CACHE_DIR="/tmp" composer install --no-dev --no-interaction --no-ansi \
  && mkdir config.d \
  && cp config.php.default config.php \
  && cp snmpd.conf.example /etc/snmp/snmpd.conf \
  && sed -i '/runningUser/d' lnms \
  && echo "foreach (glob(\"/data/config/*.php\") as \$filename) include \$filename;" >> config.php \
  && echo "foreach (glob(\"${LIBRENMS_PATH}/config.d/*.php\") as \$filename) include \$filename;" >> config.php \
  && ( \
    git clone https://github.com/librenms-plugins/Weathermap.git ./html/plugins/Weathermap \
    && cd ./html/plugins/Weathermap \
    && git reset --hard $WEATHERMAP_PLUGIN_COMMIT \
  ) \
  && chown -R nobody:nogroup ${LIBRENMS_PATH} \
  && apk del build-dependencies \
  && rm -rf .git \
    html/plugins/Test \
    html/plugins/Weathermap/.git \
    html/plugins/Weathermap/configs \
    doc/ \
    tests/ \
    /tmp/*

COPY rootfs /

EXPOSE 8000 514 514/udp 162 162/udp
VOLUME [ "/data" ]

ENTRYPOINT [ "/init" ]
