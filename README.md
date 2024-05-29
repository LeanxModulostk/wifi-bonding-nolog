# Wi-Fi Bonding NoLog [Qcom]

![](https://i.ibb.co/0hMGsNj/1690350350097.png)

## Description
This module doubles your bandwidth, disables Wi-Fi packet logging (has high overhead and several related security issues) and other logging for less background load and perhaps some battery life.

## Others tweaks manual:
- Force Wi-fi Low Latency Mode: This mode consumes more energy even if the screen is off if you want to activate it follow the steps below.
1. Open Termux and type:
su -c wifilatency
2. To disable it:
su -c wifilatencyoff

- Tcp low latency (deleted): This is a legacy option, it has no effect anymore.

- ▸ Increase Transmission Queue Length:The txqueuelen option in the ifconfig command is used to set or display the transmission queue length for a network interface on Linux. Transmission queue length refers to the maximum number of packets that can wait in the transmission queue before being sent. When you set the transmission queue length with txqueuelen, you define the maximum number of packets that can be queued for transmission on the network interface. A higher value allows for a larger transmission queue, which can be beneficial in high network load or congestion situations, as it provides more space to queue packets before they are dropped or transmission delays occur.
1. First check the value of txqueuelen with the following command (termux):
su -c "/bin/ifconfig wlan0"
2. If the default value of txqueuelen is equal to or greater than 4000 you should edit the txtweak file (system/bin) inside the module and increase the value to test.
3. To return to the default simply put the value you checked at the beginning in the following command and paste it into termux (or just reboot your device):
su -c "/bin/ifconfig wlan0 txqueuelen valor"

## Installation
1. First delete your Wi-Fi password
2. Uninstall previous version of this module (reboot)
3. Install the module in Magisk (reboot)
4. Connect to your Wi-Fi.
5. Enjoy!

## Support
- [GitHub](https://github.com/LeanxModulostk/wifi-bonding-nolog) 
- [Telegram Channel](https://t.me/modulostk)

## Special Thanks

• [Google 💩 for WCNSS_qcom_cfg.ini](https://android.googlesource.com/device/google/coral/+/refs/heads/android10-c2f2-release/WCNSS_qcom_cfg.ini)

• [Source Android for Wifi low-latency mode](https://source.android.com/docs/core/connect/wifi-low-latency)

• [simonsmh for Wifi Bonding Module](https://github.com/Magisk-Modules-Repo/wifi-bonding)

• [~~水龙&黎木汐 for reduces the number of standby wakeups~~](https://t.me/modulostk/3822)

• [syphyr for disable wifi packet logging](https://gitea.rockhost.se/Piteball/android_device_samsung_msm8976-common/commit/be2d161200b87de43d7f4f86a8176efd5627b9b1)

• [~~@Xizi1.5 for Super TCP~~](https://t.me/modulostk/99)

• [tcp_max_reordering](https://sysctl-explorer.net/net/ipv4/tcp_max_reordering/)

• [Zackptg5 for the MMT-Ex template](https://github.com/Zackptg5)

• [Topjohnwu for making Magisk](https://github.com/topjohnwu)
