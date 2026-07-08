#!/usr/bin/env bash
#
# Single-GPU passthrough hook: detach the AMD GPU from the host and hand it to
# the VM. libvirt runs every file in /var/lib/libvirt/hooks/qemu.d/ for *every*
# qemu event, so we filter on the arguments libvirt passes us:
#   $1 = guest name   $2 = operation   $3 = sub-operation
#
# This script is templated by Nix (replaceVars); the at-sign delimited tokens
# are substituted at build time.

export PATH="@binPath@:$PATH"

GUEST_NAME="$1"
OPERATION="$2"
SUB_OPERATION="$3"

# Only act for our VM, and only right before it starts.
[ "$GUEST_NAME" = "@vmName@" ] || exit 0
[ "$OPERATION" = "prepare" ] && [ "$SUB_OPERATION" = "begin" ] || exit 0

# DEBUG: trace every command to a logfile so we can see exactly where the hook
# dies (libvirt aborts the VM start if this script exits non-zero). Tail it with
# `journalctl` or `tail -f /var/log/libvirt-gpu-hook.log`. Remove when working.
exec >>/var/log/libvirt-gpu-hook.log 2>&1
echo "=== start hook $(date -Is) guest=$GUEST_NAME op=$OPERATION sub=$SUB_OPERATION ==="
set -x

# Stop the sway compositor so it releases the GPU. There is no display manager:
# sway is launched from the tty1 login shell, so killing it drops that tty back
# to a getty login prompt. Log back in on tty1 after the VM exits to get sway
# again (the stop hook rebinds the GPU).
pkill -u @user@ -x sway || true

# Stop the daemons that keep the amdgpu driver open. lactd (services.lact) and
# amdgpu-fan hold the GPU's sysfs/DRM nodes, which makes `modprobe -r amdgpu`
# fail with "Module amdgpu is in use". The stop hook restarts them.
systemctl stop lactd.service amdgpu-fan.service || true

# Give the compositor and daemons a moment to die and release DRM.
sleep 2

# Unbind the VT consoles (ignore the ones that don't exist).
for vtcon in /sys/class/vtconsole/vtcon*; do
    echo 0 > "$vtcon/bind" || true
done

# Unbind the EFI framebuffer, if present.
if [ -e /sys/bus/platform/drivers/efi-framebuffer/efi-framebuffer.0 ]; then
    echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind || true
fi

# Avoid a race between the compositor tearing down and the module unload.
sleep 1

# Unload the AMD kernel modules so the GPU can be rebound to vfio.
modprobe -r amdgpu

# If something still holds amdgpu the unload above fails but the script would
# otherwise carry on and hand libvirt a GPU that is still bound to the host,
# producing a broken VM on the emulated display. Abort loudly instead: exiting
# non-zero here makes libvirt cancel the start and run the release hook, which
# restarts the daemons and brings the desktop back. Check the log / `lsof
# /dev/dri/*` to find the remaining holder.
if [ -d /sys/module/amdgpu ]; then
    echo "ERROR: amdgpu still loaded after modprobe -r; something is holding it. Aborting." >&2
    exit 1
fi

# Detach the GPU video + audio functions from the host (binds them to vfio-pci).
virsh nodedev-detach @gpuVideo@
virsh nodedev-detach @gpuAudio@

# Make sure vfio-pci is loaded.
modprobe vfio-pci
