FROM elfabio972/baseimage-s6:debian_stretch_amd64
ARG RCLONE_VERSION
ARG RCLONE_ARCH
ENV RCLONE_VERSION ${RCLONE_VERSION:-v1.40}
ENV RCLONE_ARCH ${RCLONE_ARCH:-amd64}

COPY rootfs /

RUN apt-get update && apt-get install -y \
	fuse \
	zip


RUN echo -e "elfabio972/baseimage-s6:debian_stretch_amd64\n$RCLONE_VERSION $RCLONE_ARCH" > /rclone_version.txt

RUN curl -L --max-redirs 10 -o /tmp/rclone-${RCLONE_VERSION}-linux-${RCLONE_ARCH}.zip https://downloads.rclone.org/${RCLONE_VERSION}/rclone-${RCLONE_VERSION}-linux-${RCLONE_ARCH}.zip \
    && unzip -d /tmp /tmp/rclone-${RCLONE_VERSION}-linux-${RCLONE_ARCH}.zip */rclone \
    && mv /tmp/rclone-${RCLONE_VERSION}-linux-${RCLONE_ARCH}/rclone /usr/bin/ \
    && rm -rf /tmp/rclone-${RCLONE_VERSION}-linux-${RCLONE_ARCH}*
