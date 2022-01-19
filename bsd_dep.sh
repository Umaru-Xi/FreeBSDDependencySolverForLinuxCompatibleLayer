 #! /bin/bash

libname=""
libpath=""
defpath=""
testapp=""
echo This script will help you solve FreeBSD Linux subsystem dependent, but not reliable.
echo What the Linux exec would you want to deploy:
read testapp
echo The exec ${testapp} loading...
echo
${testapp}
echo
echo Could it running correctly? If not, remember the dependents.
echo
echo Where is the exec default libs path:
read defpath
echo Thank you.
echo
echo What is the library name:
read libname
while true
do
    echo The library ${libname} will be load.
    echo
    echo Where is the library path[default]:
    read libpath
    if [ -f ${libpath}/${libname} ];then
        echo Library exists.
    elif [ -f /lib/${libname} ];then
        echo Library dose not exists in given path, but be found in /lib.
        libpath="/lib"
    elif [ -f /usr/local/lib/${libname} ];then
        echo Library dose not exists in given path, but be found in /usr/local/lib.
        libpath="/usr/local/lib"
    elif [ -f /usr/lib/${libname} ];then
        echo Library dose not exists in given path, but be found in /usr/lib.
        libpath="/usr/lib"
    elif [ -f /usr/local/lib/qt5/${libname} ];then
        echo Library dose not exists in given path, but be found in /usr/local/lib.
        libpath="/usr/local/lib/qt5"
    elif [ -f ${defpath}/${libname} ];then
        echo Library dose not exists in given path, but be found in default path ${defpath}.
        libpath="${defpath}"
    else
        echo Library ${libpath}/${libname} does not exist.
        return 0
    fi
    sudo cp ${libpath}/${libname} /compat/linux/lib64/
    echo Library copy finished.
    echo
    echo I will do something to let it Linux binary fit to FreeBSD kernel.
    sudo brandelf -t Linux /compat/linux/lib64/${libname}
    echo Fineshed. Let us try.
    echo
    ${testapp}
    echo
    isright=""
    echo Could it running correctly?[y/libname].
    read isright
    if [ "${isright}" = "y" ]; then
        return 0
    fi
    libname=${isright}
done
