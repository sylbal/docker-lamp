#!/usr/bin/env bash

/etc/init.d/mysql start
/etc/init.d/apache2 start

# sleep until the image is terminated
sleep infinity
