# Android pattern unlock
This script sends simulated touch input over ADB for remotely swiping on
Android's pattern lockscreen.

This allows you to unlock the device even if the touch screen is broken.

Notes:
- You must have USB debugging enabled on your device for this script to work
(in the developer options).
See the [related blog post](http://ferrarimarco.info/blog/mobile/security/2017/10/18/unlocking-an-android-smartphone-with-a-known-pattern-via-adb/) for help if you did not enable it before breaking the
screen.
- The device does not need to be rooted for this method to work.
- You need to have adb on your PATH to run this script.

# Usage

```shell
chmod +x unlock.sh
./unlock.sh
```
