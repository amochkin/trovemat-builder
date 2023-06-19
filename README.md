```shell
docker build . -t jetcrypto/trovemat-builder
```

```shell
./builder_run.sh
```

# Dependency Install Scripts

## Troubleshooting

### Qt

#### Project ERROR: xcb-xfixes development package not found

```shell
sudo apt-get install libxcb-xfixes0-dev
```

#### Fatal error: can't create .obj/cdt.o: Permission denied

Inside build directory (`_build`)

```shell
sudo chown -R ${USER} .
```

Or set before build

```shell
umask 777
```

#### ERROR: Feature 'xcb' was enabled, but the pre-condition 'features.thread && libs.xcb && tests.xcb_syslibs && features.xkbcommon-x11' failed
```shell
sudo apt-get install '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev
```