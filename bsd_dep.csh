 #! /bin/csh

set libname = ""
set libpath = ""
set defpath = ""
set testapp = ""
echo "This script will help you solve FreeBSD Linux subsystem dependent, but not reliable."
echo "What the Linux exec would you want to deploy:"
set testapp = $<
echo "The exec ${testapp} loading..."
echo " "
$testapp
echo " "
echo "Could it running correctly? If not, remember the dependents."
echo " "
echo "Where is the exec default libs path:"
set defpath = $<
echo "Thank you."
echo " "
echo "What is the library name:"
set libname = $<
while(1)
    echo "The library ${libname} will be load."
    echo " "
    echo "Where is the library path[default]:"
   set libpath = $<
    if( -f ${libpath}/${libname} ) then
        echo "Library exists."
    else if( -f /lib/${libname} ) then
        echo "Library dose not exists in given path, but be found in /lib."
        set libpath = "/lib"
    else if( -f /usr/local/lib/${libname} ) then
        echo "Library dose not exists in given path, but be found in /usr/local/lib."
        set libpath = "/usr/local/lib"
    else if( -f /usr/lib/${libname} ) then
        echo "Library dose not exists in given path, but be found in /usr/lib."
        set libpath = "/usr/lib"
    else if( -f /usr/local/lib/qt5/${libname} ) then
        echo "Library dose not exists in given path, but be found in /usr/local/lib."
        set libpath = "/usr/local/lib/qt5"
    else if( -f ${defpath}/${libname} ) then
        echo "Library dose not exists in given path, but be found in default path ${defpath}."
        set libpath = "${defpath}"
    else
        echo "Library ${libpath}/${libname} does not exist."
        exit 0
    endif
    sudo cp ${libpath}/${libname} /compat/linux/lib64/
    echo "Library copy finished."
    echo " "
    echo "I will do something to let it Linux binary fit to FreeBSD kernel."
    sudo brandelf -t Linux /compat/linux/lib64/${libname}
    echo "Fineshed. Let us try."
    echo " "
    ${testapp}
    echo " "
    set isright = ""
    echo "Could it running correctly?[y/libname]."
    set isright = $<
    if( "${isright}" == "y" ) then
        exit 0
    endif
    set libname = ${isright}
end
