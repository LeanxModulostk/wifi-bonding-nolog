ui_print ""
ui_print ""
ui_print "▒█░░▒█ ░▀░ ░░ ▒█▀▀▀ ░▀░ "
ui_print "▒█▒█▒█ ▀█▀ ▀▀ ▒█▀▀▀ ▀█▀ "
ui_print "▒█▄▀▄█ ▀▀▀ ░░ ▒█░░░ ▀▀▀ "
ui_print " "
ui_print "▒█▀▀█ █▀▀█ █▀▀▄ █▀▀▄ ░▀░ █▀▀▄ █▀▀▀ "
ui_print "▒█▀▀▄ █░░█ █░░█ █░░█ ▀█▀ █░░█ █░▀█ "
ui_print "▒█▄▄█ ▀▀▀▀ ▀░░▀ ▀▀▀░ ▀▀▀ ▀░░▀ ▀▀▀▀ "
ui_print " "
ui_print "▒█▄░▒█ █▀▀█ ▒█░░░ █▀▀█ █▀▀▀ "
ui_print "▒█▒█▒█ █░░█ ▒█░░░ █░░█ █░▀█ "
ui_print "▒█░░▀█ ▀▀▀▀ ▒█▄▄█ ▀▀▀▀ ▀▀▀▀"
ui_print ""
ui_print ""
[ -x `which magisk` ] && {
if magisk --denylist ls &>/dev/null; then
CMDPREFIX="magisk --denylist exec"
elif magisk magiskhide ls &>/dev/null; then
CMDPREFIX="magisk magiskhide exec"
fi
} || unset CMDPREFIX

CHECK_DIRS="/system /vendor /product /system_ext"
EXISTING_DIRS=""
for dir in $CHECK_DIRS; do
[[ -d "$dir" ]] && EXISTING_DIRS="$EXISTING_DIRS $dir"
done

CFGS=$($CMDPREFIX find $EXISTING_DIRS -type f -name WCNSS_qcom_cfg.ini)
for CFG in $CFGS
do
[[ -f $CFG ]] && {
mkdir -p `dirname $MODPATH$CFG`
ui_print "- Migrating $CFG"
$CMDPREFIX cp -af $CFG $MODPATH$CFG
ui_print "- Starting modify"
sed -i '/gChannelBondingMode24GHz=/d;/gChannelBondingMode5GHz=/d;/gForce1x1Exception=/d;/sae_enabled=/d;/BandCapability=/d;/wlanLoggingEnable=/d;/wlanLoggingFEToConsole=/d;/gEnableDebugLog=/d;/gFwDebugLogType=/d;/gFwDebugLogLevel=/d;/gEnablefwlog=/d;/gEnablePacketLog=/d;/gEnableNUDTracking=/d;/gEnableLogp=/d;/gFwDebugLogLevel=/d;/gFwDebugModuleLoglevel=/d;s/^END$/gChannelBondingMode24GHz=1\ngChannelBondingMode5GHz=1\ngForce1x1Exception=0\nsae_enabled=1\nBandCapability=0\nwlanLoggingEnable=0\nwlanLoggingFEToConsole=0\ngEnableDebugLog=0\ngFwDebugLogType=0\ngFwDebugLogLevel=0\ngEnablefwlog=0\ngEnablePacketLog=0\ngEnableNUDTracking=0\ngEnableLogp=0\nEND/g' $MODPATH$CFG

# Find and modify xtwifi.conf
xtwifi_conf=$($CMDPREFIX find $EXISTING_DIRS -type f -name xtwifi.conf)
if [ -n "$xtwifi_conf" ]; then
    xtwifi_dir=$(dirname $xtwifi_conf)
    mkdir -p $MODPATH/$xtwifi_dir
    $CMDPREFIX cp -af $xtwifi_conf $MODPATH/$xtwifi_dir
    sed -i -e 's/DEBUG_GLOBAL_LOG_LEVEL = [0-9]*/DEBUG_GLOBAL_LOG_LEVEL = 0/g' $MODPATH/$xtwifi_dir/xtwifi.conf
fi
}
done

[[ -z $CFG ]] && abort "- Installation FAILED. Your device didn't support WCNSS_qcom_cfg.ini." || { mkdir -p $MODPATH/system; mv -f $MODPATH/vendor $MODPATH/system/vendor; mv -f $MODPATH/product $MODPATH/system/product; mv -f $MODPATH/system_ext $MODPATH/system/system_ext;}