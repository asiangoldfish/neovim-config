#!/usr/bin/env bash

sudo pacman -S docker

sudo usermod -aG docker $USER

sudo systemctl enable docker.service
sudo systemctl enable containerd.service
