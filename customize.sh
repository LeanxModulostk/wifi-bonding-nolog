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

#!/bin/sh

# Function to replace a line in a file
replace_line() {
    local file=$1
    local search=$2
    local replace=$3
    sed -i "s/${search}/$replace/g" $file
}

# Check if Magisk is installed and set the MIRRORPATH variable
if [ -x "$(which magisk)" ]; then
    MIRRORPATH=$(magisk --path)/.magisk/mirror
else
    unset MIRRORPATH
fi

# Find WCNSS_qcom_cfg.ini files
array=$(find /system /vendor /product /system_ext -name WCNSS_qcom_cfg.ini)

for CFG in $array; do
    if [ -f $CFG ] && [ ! -L $CFG ]; then
        SELECTPATH=$CFG
        mkdir -p $(dirname $MODPATH$CFG)
        ui_print "- Migrating $MIRRORPATH$SELECTPATH"
        cp -af $MIRRORPATH$SELECTPATH $MODPATH$SELECTPATH
        ui_print "- Starting modify"

        # Modify WCNSS_qcom_cfg.ini
        sed -i '/gChannelBondingMode24GHz=/d;/gChannelBondingMode5GHz=/d;/gForce1x1Exception=/d;/sae_enabled=/d;/gEnablefwlog=/d;/gEnablePacketLog=/d;/gEnableNUDTracking=/d;/gEnableLogp=/d;/gFwDebugLogLevel=/d;/gFwDebugModuleLoglevel=/d;s/^END$/gChannelBondingMode24GHz=1\ngChannelBondingMode5GHz=1\ngForce1x1Exception=0\nsae_enabled=1\ngEnablefwlog=0\ngEnablePacketLog=0\ngEnableNUDTracking=0\ngEnableLogp=0\nEND/g' $MODPATH$SELECTPATH

        # Find and copy icm.conf file
        icm_conf=$(find $(dirname $CFG) -name icm.conf)
        if [ -n "$icm_conf" ]; then
            cp -af $icm_conf $MODPATH$(dirname $CFG)
            
            # Modify icm.conf
            replace_line "$MODPATH$icm_conf" "debug_module_bitmap=255" "debug_module_bitmap=0"
            replace_line "$MODPATH$icm_conf" "debug_level=2" "debug_level=1"
        fi
    fi
done

if [ -z "$SELECTPATH" ]; then
    abort "- Installation FAILED. Your device doesn't support WCNSS_qcom_cfg.ini."
else
    mkdir -p $MODPATH/system
    mv -f $MODPATH/vendor $MODPATH/system/vendor
    mv -f $MODPATH/product $MODPATH/system/product
    mv -f $MODPATH/system_ext $MODPATH/system/system_ext
fi