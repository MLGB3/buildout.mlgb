#! /bin/bash
#===================================================================================================
# Photos uploaded by users will generally be too large to be suitable for display on the web, so:
# 1. Copy each large photo to a separate directory for later archiving in digital.bodleian
# 2. Resize the original version of the large photo to a smaller size using ImageMagick
#===================================================================================================
# This script must be run by root, 
# as the original files are owned by www-data having been uploaded via web.
#===================================================================================================

indir=/home/mlgb/sites/mlgb/static/media/photos
outdir=/home/mlgb/sites/mlgb/static/media/photos_archive

new_width=1000
archive_file_owner=mlgb

cd $indir
for f in $(ls | grep -v "\.thumb\.")
do
  if [ -f $f ]
  then
    archive_file=${outdir}/$f
    if [ ! -f $archive_file ]
    then
      echo "Archiving original version of $f to $outdir"
      cp $f $archive_file

      echo "Creating smaller version of $f for web display"
      convert $f -resize ${new_width}\> $f  # the \> flag means 'only shrink, never enlarge'

      chown $archive_file_owner $archive_file
      chgrp $archive_file_owner $archive_file
    fi
  fi
done

