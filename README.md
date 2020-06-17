# l4t-base with apt sources

This image deespstream samples with Nvidia's apt sources, so you can build using it without `nvidia`
[as the default runtime](https://forums.developer.nvidia.com/t/suggestion-to-solve-tegra-nvidia-docker-issues/117522/11?u=mdegans).

Deepstream /opt folder permissions are also fixed as well as ldconfig and suid
binaries disabled.

## Requirements

- a Tegra board
- Linux for Tegra with Docker running
