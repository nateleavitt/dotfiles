DEV_ROOT="${DEV_ROOT:-$HOME/Code}"

cn8() { cd "${DEV_ROOT}/github.com/n8bit/$1"; }
compctl -W "${DEV_ROOT}/github.com/n8bit/" -/ cn8

cn() { cd "${DEV_ROOT}/github.com/nateleavitt/$1"; }
compctl -W "${DEV_ROOT}/github.com/nateleavitt/" -/ cn

cl() { cd "${DEV_ROOT}/github.com/loyalstream/$1"; }
compctl -W "${DEV_ROOT}/github.com/loyalstream/" -/ cl

cdev() { cd "${DEV_ROOT}/github.com/$1"; }
compctl -W "${DEV_ROOT}/github.com/" -/ cdev