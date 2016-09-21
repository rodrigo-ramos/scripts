#!/bin/sh

MAGO=$(date --date='-0 month' +'%Y-%m')
ROOTPATH="/mnt/log_disk/"
BACKUP="backups/"
ARCHIVES="archives/"
LOGPATH1="MTAPIAS01-mt-api-1/"
LOGPATH2="MTAPIAS01-mt-api-2/"
LOGPATH3="MTAPIAS02-1-mt-api-1/"
LOGPATH4="MTAPIAS02-1-mt-api-2/"
LOGPATH5="MTAPIAS03-1-mt-api-1/"
LOGPATH6="MTAPIAS03-1-mt-api-1/"
LOGPATH7="MTAPIAS04-1-mt-api-1/"
LOGPATH8="MTAPIAS04-1-mt-api-2/"

#
# Mueve los archivos que coincidan con el criterio de seleccion. 
#
function find_by_month() {
TMPFILE="findtmp.txt"
mkdir $1$2$3 2>/dev/null
if [ ! -e $1$2$3 ]; then                                                                                                                                                     
    echo "ERROR. No es posible crear la carpeta de respaldo."                                                                                                                
else                                                                                                                                                                         
# Busca todos los logs del mes especificado en la variable MAGO partiendo de la ruta especificada en la variable LOGPATH
find $1$2 -type f -exec ls --full-time {} \; | grep -v $ARCHIVES | grep -v $BACKUP | awk -v var=$MAGO '{ if (match($6,var)) {print $9}}' | sort -r -k1 > $TMPFILE
echo "Buscando archivos con la fecha $MAGO en la carpeta $1$2"
# Comprime la lista de archivos encontrados en el procedimiento anterior.
if [ -s $TMPFILE ]; then
while read line;
do
        echo "Moviendo archivos para su compresión $line $1$2$3"
        mv $line $1$2$3
done < $TMPFILE
> $TMPFILE
fi
fi
}


function compress() {
FILES="compress.txt"
mkdir $1$2$4 2>/dev/null
if [ ! -d $1$2$4 ]; then
    echo "ERROR. No es posible crear la carpeta de almacenamiento."
else
ls $1$2$3 > $FILES
if [ -s $FILES ]; then
while read ln
do
    echo "Comprimiendo archivos: $1$2$3$ln"
    bzip2 $1$2$3$ln 2>/dev/null
    #sleep 10;
        echo "Moviendo los archihvos comprimidos $1$2$3$ln a la ruta $1$2$4"
        mv $1$2$3$ln* $1$2$4
done < $FILES
else 
        echo "No hay archivos que comprimir en la ruta $1$2$3"
fi
> $FILES
fi
}

find_by_month $ROOTPATH $LOGPATH1 $BACKUP
find_by_month $ROOTPATH $LOGPATH2 $BACKUP
find_by_month $ROOTPATH $LOGPATH3 $BACKUP
find_by_month $ROOTPATH $LOGPATH4 $BACKUP
find_by_month $ROOTPATH $LOGPATH5 $BACKUP
find_by_month $ROOTPATH $LOGPATH6 $BACKUP
find_by_month $ROOTPATH $LOGPATH7 $BACKUP
find_by_month $ROOTPATH $LOGPATH8 $BACKUP

compress $ROOTPATH $LOGPATH1 $BACKUP $ARCHIVES
compress $ROOTPATH $LOGPATH2 $BACKUP $ARCHIVES
compress $ROOTPATH $LOGPATH3 $BACKUP $ARCHIVES
compress $ROOTPATH $LOGPATH4 $BACKUP $ARCHIVES
compress $ROOTPATH $LOGPATH5 $BACKUP $ARCHIVES
compress $ROOTPATH $LOGPATH6 $BACKUP $ARCHIVES
compress $ROOTPATH $LOGPATH7 $BACKUP $ARCHIVES
compress $ROOTPATH $LOGPATH8 $BACKUP $ARCHIVES

