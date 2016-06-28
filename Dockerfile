FROM vyolin/alpine-maven:latest

RUN apk --update add git ffmpeg flac lame && \
    git clone --depth 1 -b janssonic https://github.com/Der-Jan/supersonic.git /tmp/subsonic && \
    cd /tmp/subsonic && \
    mvn install -P full && \
    cd subsonic-assembly && \
    mvn assembly:assembly && \
    mkdir -p /opt/subsonic && \
    mv target/subsonic-6.0-standalone.tar.gz /opt/subsonic && \
    cd /opt/subsonic && \
    tar zxvf subsonic-6.0-standalone.tar.gz && \
    mkdir -p /var/subsonic/transcode && \
    ln -s /usr/bin/lame /var/subsonic/transcode/lame && \
    ln -s /usr/bin/ffmpeg /var/subsonic/transcode/ffmpeg && \
    rm -rf /tmp/* && \
    apk del git && \
    rm -rf /var/cache/apk/*

VOLUME ["/var/subsonic"]
VOLUME ["/var/music"]
VOLUME ["/var/playlists"]

EXPOSE 4040

CMD /opt/subsonic/subsonic.sh && sleep 5 && tail -f /var/subsonic/subsonic_sh.log

