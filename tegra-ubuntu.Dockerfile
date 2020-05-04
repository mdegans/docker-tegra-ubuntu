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

ARG JETPACK_VERSION=r32.3.1

FROM nvcr.io/nvidia/l4t-base:${JETPACK_VERSION} as base

# because Nvidia has no keyserver for Tegra currently, we DL the whole BSP tarball, just for the apt key.
ARG BSP_URI="https://developer.nvidia.com/embedded/dlc/r32-3-1_Release_v1.0/t210ref_release_aarch64/Tegra210_Linux_R32.3.1_aarch64.tbz2"
ARG BSP_SHA512="13c4dd8e6b20c39c4139f43e4c5576be4cdafa18fb71ef29a9acfcea764af8788bb597a7e69a76eccf61cbedea7681e8a7f4262cd44d60cefe90e7ca5650da8a"

WORKDIR /tmp
# install apt key and configure apt sources
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
    && BSP_SHA512_ACTUAL="$(wget --https-only -nv --show-progress --progress=bar:force:noscroll -O- ${BSP_URI} | tee bsp.tbz2 | sha512sum -b | cut -d ' ' -f 1)" \
    && [ ${BSP_SHA512_ACTUAL} = ${BSP_SHA512} ] \
    && echo "Extracting bsp.tbz2" \
    && tar --no-same-permissions -xjf bsp.tbz2 \
    && cp Linux_for_Tegra/nv_tegra/jetson-ota-public.key /etc/apt/trusted.gpg.d/jetson-ota-public.asc \
    && chmod 644 /etc/apt/trusted.gpg.d/jetson-ota-public.asc

# This determines what <SOC> gets filled in in the nvidia apt sources list:
# putting it here so there's a common layer for all boards and build_all.sh builds faster
# valid choices: t210, t186, t194 
ARG SOC="t210"

RUN echo "deb https://repo.download.nvidia.com/jetson/common r32 main" > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list \
    && echo "deb https://repo.download.nvidia.com/jetson/${SOC} r32 main" >> /etc/apt/sources.list.d/nvidia-l4t-apt-source.list \
    && apt-get update
# the final apt-get update to test it works.

# Finally, copy the working stuff to a fresh base,
# just in case there are some files still around
FROM nvcr.io/nvidia/l4t-base:${JETPACK_VERSION}

COPY --from=base /etc/apt/trusted.gpg.d/jetson-ota-public.asc /etc/apt/trusted.gpg.d/jetson-ota-public.asc
COPY --from=base /etc/apt/sources.list.d/nvidia-l4t-apt-source.list /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
ENV SUDO_FORCE_REMOVE=yes
RUN apt-get purge -y --autoremove sudo \
    &&  for f in $(find / -perm 4000); do chmod -s "$f"; done;
# sudo should not be in an image, among other suid binaries
