# ApeX Plymouth theme

The boot splash theme used by ApeX OS. The files live in `apex/`:

- `apex.plymouth` — theme descriptor
- `apex.script` — Plymouth script that drives the animation
- `fade-apex.py` — run at image-build time to generate the `progress-N.png` frame sequence from `target.png`
- `target.png` — source logo

The top-level `Containerfile` copies these directly into `/usr/share/plymouth/themes/apex/` and runs `fade-apex.py` during build. There is no separate RPM build step — edit the files in place and rebuild the container image.
