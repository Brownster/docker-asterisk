#!/bin/bash

# Give everything meaningful names
NAME_ASTERISK=asterisk
NAME_FASTAGI=fastagi

# Run the fastagi container.
docker run \
	-p 4573:4573 \
	--name $NAME_FASTAGI \
	-d -t dougbtv/fastagi

# Run the main asterisk container.
docker run \
    --name $NAME_ASTERISK \
    --net=host \
    -d -t brownster/unraid-asterisk-docker

# -----------------------------
# Some helpful debug stuff...
# docker run --name $NAME_ASTERISK --net=host -d -t brownster/unraid-asterisk-docker
# For testing use:
# docker run --name $NAME_ASTERISK --net=host -i -t brownster/unraid-asterisk-docker bin/bash
