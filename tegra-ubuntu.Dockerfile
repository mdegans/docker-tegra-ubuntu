# MIT License

# Copyright (c) 2020 Michael de Gans

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

ARG JETPACK_VERSION=r32.4.4
ARG BASE_IMAGE=nvcr.io/nvidia/l4t-base:${JETPACK_VERSION}

FROM ${BASE_IMAGE} as base

ARG SOC="t210"

ADD --chown=root:root https://repo.download.nvidia.com/jetson/jetson-ota-public.asc /etc/apt/trusted.gpg.d/jetson-ota-public.asc
RUN chmod 644 /etc/apt/trusted.gpg.d/jetson-ota-public.asc \
    && apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
    && echo "deb https://repo.download.nvidia.com/jetson/common r32 main" > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list \
    && echo "deb https://repo.download.nvidia.com/jetson/${SOC} r32 main" >> /etc/apt/sources.list.d/nvidia-l4t-apt-source.list \
    && apt-get update \
    && rm -rf /var/lib/apt/lists/*
# the last two lines are just to test it works. Leaving the ca-certificates
# package in is intentional, since nvidia uses https sources and without that,
# apt will complain about "Certificate verification failed: The certificate is
# NOT trusted. The certificate issuer is unknown.  Could not handshake: Error
# in the certificate verification. [IP: 23.221.236.160 443]"
# You will probably want to update ca-certificates in each apt stanza in each
# derived image since certificates can be revoked periodically and that package
# should always be up to date.
