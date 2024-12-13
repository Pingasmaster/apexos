## 1. BUILD ARGS
# These allow changing the produced image by passing different build args to adjust
# the source from which your image is built.
# Build args can be provided on the commandline when building locally with:
#   podman build -f Containerfile --build-arg FEDORA_VERSION=40 -t local-image

# SOURCE_IMAGE arg can be anything from ublue upstream which matches your desired version:
# See list here: https://github.com/orgs/ublue-os/packages?repo_name=main
# - "silverblue"
# - "kinoite"
# - "sericea"
# - "onyx"
# - "lazurite"
# - "vauxite"
# - "base"
#
#  "aurora", "bazzite", "bluefin" or "ucore" may also be used but have different suffixes.
ARG SOURCE_IMAGE="silverblue"

## SOURCE_SUFFIX arg should include a hyphen and the appropriate suffix name
# These examples all work for silverblue/kinoite/sericea/onyx/lazurite/vauxite/base
# - "-main"
# - "-nvidia"
# - "-asus"
# - "-asus-nvidia"
# - "-surface"
# - "-surface-nvidia"
#
# aurora, bazzite and bluefin each have unique suffixes. Please check the specific image.
# ucore has the following possible suffixes
# - stable
# - stable-nvidia
# - stable-zfs
# - stable-nvidia-zfs
# - (and the above with testing rather than stable)
ARG SOURCE_SUFFIX="-main"

## SOURCE_TAG arg must be a version built for the specific image: eg, 39, 40, gts, latest
ARG SOURCE_TAG="latest"


### 2. SOURCE IMAGE
## this is a standard Containerfile FROM using the build ARGs above to select the right upstream image
FROM ghcr.io/ublue-os/${SOURCE_IMAGE}${SOURCE_SUFFIX}:${SOURCE_TAG}


### 3. MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

# Copy yafti config (used to present the user with flatpak install choices on first boot)
COPY yafti.yml /etc/yafti.yml
# Copy build config
COPY build.sh /tmp/build.sh
# Copy icon file needed for yafti config on first boot
COPY logo-500x500-dark.png /var/icon.png
# Copy apex logo plymouth theme for boot logo
RUN mkdir -p /usr/share/plymouth/themes/apex/ /temp/rpm-custom-plymouth-theme/apex/ /temp/rpm-custom-plymouth-theme/rpmbuild/SPECS/
COPY rpm-custom-plymouth-theme/* /temp/rpm-custom-plymouth-theme/
COPY rpm-custom-plymouth-theme/apex/* /temp/rpm-custom-plymouth-theme/apex/
COPY rpm-custom-plymouth-theme/rpmbuild/SPECS/* /temp/rpm-custom-plymouth-theme/rpmbuild/SPECS/

# Run BlueBuild's gnome-extensions module
RUN \
  # add in the module source code
  --mount=type=bind,from=ghcr.io/blue-build/modules:latest,src=/modules,dst=/tmp/modules,rw \
  # add in the script that sets up the module run environment
  --mount=type=bind,from=ghcr.io/blue-build/cli/build-scripts:latest,src=/scripts/,dst=/tmp/scripts/ \
  # run the module
  /tmp/scripts/run_module.sh 'gnome-extensions' \
    '{"type":"gnome-extensions","install":["Bluetooth Battery Meter","Blur my Shell","Caffeine","Compiz windows effect","GSConnect","Just Perfection","Quick Lofi","Transparent Window Moving","Wallpaper Slideshow",5470]}'

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    ostree container commit


RUN mkdir -p /var/lib/alternatives && \
    pip install --prefix=/usr yafti && \
    ostree container commit

## NOTES:
# - /var/lib/alternatives is required to prevent failure with some RPM installs
# - All RUN commands must end with ostree container commit
#   see: https://coreos.github.io/rpm-ostree/container/#using-ostree-container-commit
