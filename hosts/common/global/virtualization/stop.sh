#!/usr/bin/env bash
#
# Single-GPU passthrough hook: reattach the AMD GPU to the host after the VM
# shuts down. See start.sh for how libvirt invokes this (same qemu.d mechanism,
# same argument filtering).
#   $1 = guest name   $2 = operation   $3 = sub-operation
#
# Templated by Nix (replaceVars).

export PATH="@binPath@:$PATH"

GUEST_NAME="$1"
OPERATION="$2"
SUB_OPERATION="$3"

# Only act for our VM, and only after it has released its devices.
[ "$GUEST_NAME" = "@vmName@" ] || exit 0
[ "$OPERATION" = "release" ] && [ "$SUB_OPERATION" = "end" ] || exit 0

# Unbind the GPU functions from vfio-pci and give them back to the host.
virsh nodedev-reattach @gpuVideo@
virsh nodedev-reattach @gpuAudio@

# Unload vfio-pci now that nothing is using it.
modprobe -r vfio-pci || true

# Reload the AMD kernel modules.
modprobe amdgpu

# Rebind the EFI framebuffer, if present.
if [ -d /sys/bus/platform/drivers/efi-framebuffer ]; then
    echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind || true
fi

# Rebind the VT consoles.
for vtcon in /sys/class/vtconsole/vtcon*; do
    echo 1 > "$vtcon/bind" || true
done

# At this point the GPU is back on the host but sway is not running. Log in on
# tty1 to relaunch it (your zsh profile execs sway there).
