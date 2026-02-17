#!/bin/bash

#sudo usermod -aG docker $USER

#newgrp docker

xhost +local:docker

docker run -it --rm \
  --runtime nvidia \
  --network host \
  --device /dev/video0:/dev/video0 \
  --volume ~/ML_AI/docker-workspace:/workspace \
  --workdir /workspace \
  --env PIP_INDEX_URL=https://pypi.org/simple \
  --dns 8.8.8.8 \
  --privileged \
  --volume /tmp/argus_socket:/tmp/argus_socket \
  --volume /etc/enctune.conf:/etc/enctune.conf \
  --volume /etc/nv_tegra_release:/etc/nv_tegra_release \
  --volume /tmp/nv_jetson_model:/tmp/nv_jetson_model \
  --device /dev/nvhost-ctrl \
  --device /dev/nvhost-ctrl-gpu \
  --device /dev/nvhost-prof-gpu \
  --device /dev/nvmap \
  --device /dev/nvhost-gpu \
  --device /dev/nvhost-as-gpu \
  --env DISPLAY=$DISPLAY \
  --volume /temp/.X11-unix:/tmp/.X11-unix:rw \
  --env QT_X11_NO_MITSHM=1 \
  yolo-jetson
  #bash -c "pip3 install -q ultralytics && exec bash"
  
