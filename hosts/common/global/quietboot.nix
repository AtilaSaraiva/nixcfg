{
  boot.kernelParams = [ "quiet" "udev.log_level=3" "preempt=voluntary" ];
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
}
