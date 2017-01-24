FROM ubuntu:16.10
COPY scripts /scripts
RUN bash /scripts/add_spotify_repo.sh
RUN bash /scripts/install_pkgs.sh
ENV PUlSE_SERVER=unix:/pulse-sock
ENV DISPLAY :0
RUN mkdir -p /run/dbus
RUN dbus-daemon --system --fork --nopidfile
ENV HOME=/home
ENV DBUS_SESSION_BUS_ADDRESS="unix:path=/run/dbus/system_bus_socket"
COPY asound.conf /etc/asound.conf
COPY pulse-client.conf /etc/pulse/client.conf

RUN mkdir -p /home/spotify/.cache/spotify
ENV HOME /home/spotify
RUN useradd --create-home --home-dir $HOME spotify \
    && gpasswd -a spotify audio \
    && chown -R spotify:spotify $HOME
WORKDIR $HOME
USER spotify

CMD spotify
