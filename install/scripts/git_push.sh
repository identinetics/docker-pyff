#!/usr/bin/env bash

cd /var/md_feed/
git add --all
git commit -m "generated by $DOCKERHOSTNAME"
git push
