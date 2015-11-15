FROM ubuntu:14.04.2
MAINTAINER Doro Wu <fcwu.tw@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends supervisor \
        openssh-server pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        firefox \
        nginx \
        python-pip python-dev build-essential \
	xdg-utils \
	imagemagick \
	bc \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

ADD https://dl.dropboxusercontent.com/u/23905041/x11vnc_0.9.14-1.1ubuntu1_amd64.deb /tmp/
ADD https://dl.dropboxusercontent.com/u/23905041/x11vnc-data_0.9.14-1.1ubuntu1_all.deb /tmp/
ADD https://update.send-anywhere.com/linux_downloads/sendanywhere_latest_amd64.deb /tmp/
RUN dpkg -i /tmp/x11vnc*.deb
RUN dpkg -i /tmp/sendanywhere*.deb

ADD web /web/
RUN pip install -r /web/requirements.txt

ADD noVNC /noVNC/
ADD nginx.conf /etc/nginx/sites-enabled/default
ADD startup.sh /
ADD supervisord.conf /etc/supervisor/conf.d/
ADD config.ini /tmp/
ADD ubuntu_crontab /tmp/
ADD process_uploads.sh /tmp/

EXPOSE 6080
WORKDIR /root
ENTRYPOINT ["/startup.sh"]
