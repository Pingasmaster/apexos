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
# Copy yafti config file & firstboot desktop file
COPY yafti.yml /etc/yafti.yml
COPY yafti-firstboot.desktop /etc/xdg/autostart/yafti-firstboot.desktop
# Copy posts install scripts
COPY script-post-install-root.sh script-post-install-user.sh /etc/
# Copy icon file needed for yafti config on first boot
COPY icon.png /etc/icon.png
# Copy source logo into the build layer; regenerated into hicolor sizes below, then removed
COPY logo.png /tmp/apexos-logo.png
# Prepare directories, swap the base os-release for ours, and remove the Fedora hicolor logo icons
RUN rm -f /etc/os-release && \
mkdir -p /usr/share/plymouth/themes/apex/ && \
mkdir -p /usr/share/backgrounds/apexos/ && \
mkdir -p /usr/share/gnome-background-properties/ && \
mkdir -p /etc/apexos && \
chmod 555 /etc/script-post-install-root.sh /etc/script-post-install-user.sh && \
rm -f /usr/share/icons/hicolor/16x16/apps/fedora-logo-icon.png \
/usr/share/icons/hicolor/22x22/apps/fedora-logo-icon.png \
/usr/share/icons/hicolor/24x24/apps/fedora-logo-icon.png \
/usr/share/icons/hicolor/256x256/apps/fedora-logo-icon.png \
/usr/share/icons/hicolor/32x32/apps/fedora-logo-icon.png \
/usr/share/icons/hicolor/36x36/apps/fedora-logo-icon.png \
/usr/share/icons/hicolor/48x48/apps/fedora-logo-icon.png \
/usr/share/icons/hicolor/96x96/apps/fedora-logo-icon.png && \
ostree container commit
COPY rpm-custom-plymouth-theme/apex/ /usr/share/plymouth/themes/apex/
COPY plymouthd.conf /etc/plymouth/
# Copy config file for os-release to rename to apexos
COPY os-release /etc/
# Copy wallpapers, XML metadata (canonical GNOME path), and default background schema override
COPY default-light.png default-dark.png /usr/share/backgrounds/apexos/
COPY apexos.xml /usr/share/gnome-background-properties/apexos.xml
COPY 10_apexos-background.override /usr/share/glib-2.0/schemas/
# Stash the snapper config for /home; post-install-root applies it after snapper create-config
COPY home-dir-backup /etc/apexos/home-dir-backup.conf

# Install necessary gnome extensions
RUN \
  # add in the module source code
  --mount=type=bind,from=ghcr.io/blue-build/modules:latest,src=/modules,dst=/tmp/modules,rw \
  # add in the script that sets up the module run environment
  --mount=type=bind,from=ghcr.io/blue-build/cli/build-scripts:latest,src=/scripts/,dst=/tmp/scripts/ \
  # run the module
  /tmp/scripts/run_module.sh 'gnome-extensions' \
    '{"type":"gnome-extensions","install":["Bluetooth Battery Meter","Blur my Shell","Caffeine","Compiz windows effect","GSConnect","Just Perfection","Quick Lofi","Transparent Window Moving","Wallpaper Slideshow",5470]}'

# Install software, generate plymouth frames & hicolor icons, compile schemas, remove firefox, install yafti
RUN mkdir -p /var/lib/alternatives && \
set -ouex pipefail && \
RELEASE="$(rpm -E %fedora)" && \
rpm-ostree install screen vlc python3 python3-pip python3-pillow plymouth-plugin-script snapper && \
rpm-ostree override remove firefox firefox-langpacks && \
python3 /usr/share/plymouth/themes/apex/fade-apex.py && \
for S in 16 22 24 32 36 48 96 256; do \
  mkdir -p /usr/share/icons/hicolor/${S}x${S}/apps && \
  python3 -c "from PIL import Image; Image.open('/tmp/apexos-logo.png').resize((${S}, ${S}), Image.LANCZOS).save('/usr/share/icons/hicolor/${S}x${S}/apps/apexos-logo-icon.png')"; \
done && \
rm -f /tmp/apexos-logo.png && \
gtk-update-icon-cache -f /usr/share/icons/hicolor && \
glib-compile-schemas /usr/share/glib-2.0/schemas/ && \
pip install --prefix=/usr --break-system-packages yafti && \
ostree container commit

## NOTES:
# - /var/lib/alternatives is required to prevent failure with some RPM installs
# - All RUN commands must end with ostree container commit
#   see: https://coreos.github.io/rpm-ostree/container/#using-ostree-container-commit
 
