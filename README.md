# Ubuntu Image for Tegra

This image is intended to provide an alternative to the l4t-base image from Nvidia that lacks cuda inside the image, making it impossible to build `FROM`.

It also exchews any Tegra specific customizations to Ubuntu. This is basically stock `ubuntu:bionic` with Nvidia's apt repos and CUDA.

**NOTE**: due to an apparent bug in `--runtime nvidia`, files won't be mounted at runtime, so **this branch should be considered broken for the moment**.
Please use the [l4t-base branch](https://github.com/mdegans/docker-tegra-ubuntu/tree/l4t-base) instead, since `runtime --nvidia` works.

## Requirements

- a Tegra board
- Linux for Tegra with Docker running

## Example usage of built image:



## Building

A build script is provided to 