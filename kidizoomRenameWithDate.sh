#! /bin/bash

# set SOURCE_DIR to the path of the directory containing the movies you want to convert.
# This should be a flat list of movies with no sub-directories
SOURCE_DIR="/Users/thom/Desktop/input movies"

# set OUTPUT_DIR to the path of the directory where you would like the
# renamed movies to be copied to
OUTPUT_DIR="/Users/thom/Desktop/output movies"

for FILE in `ls "${SOURCE_DIR}"`; do

  FILEPATH="${SOURCE_DIR}"/$FILE
  #FILEEXT=`echo $FILEPATH | awk -F . '{print $NF}'`

  # for this camera the output looks like
  # 2016:12:24`
  # will need to trim (cut) off that weird trailing char
  DATECREATED=`exiftool -DateCreated -b "$FILEPATH"`
  YEAR=`echo $DATECREATED | awk -F ':' '{print $1}'`
  MONTH=`echo $DATECREATED | awk -F ':' '{print $2}'`
  DAY=`echo $DATECREATED | awk -F ':' '{print $3}' | cut -c1-2`

  NEWFILENAME=`echo "${YEAR}-${MONTH}-${DAY}_${FILE}"`

  cp "$FILEPATH" "${OUTPUT_DIR}/${NEWFILENAME}"
  touch -c -t ${YEAR}${MONTH}${DAY}0000 "${OUTPUT_DIR}/${NEWFILENAME}"

  echo "Copying ${FILE} to ${OUTPUT_DIR}/${NEWFILENAME}"

done
