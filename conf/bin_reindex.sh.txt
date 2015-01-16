#! /bin/bash

echo 'Enabling numeric sorting by shelfmark...'
/home/mlgb/sites/mlgb/mysite/books/set_shelfmark_sort.sh $MLGBADMINPW > /home/mlgb/sites/mlgb/parts/jobs/set_shelfmark_sort.log 2>&1

echo 'Enabling sorting by date...'
/home/mlgb/sites/mlgb/mysite/books/set_date_sort.sh $MLGBADMINPW > /home/mlgb/sites/mlgb/parts/jobs/set_date_sort.log 2>&1

echo 'Generating links from author/title index to MLGB book records...'
cd /home/mlgb/sites/mlgb/parts/index
python setIndexBookIDs.py > /home/mlgb/sites/mlgb/parts/jobs/IndexBookIDs.log 2>&1

echo 'Stripping out HTML/XML comments so they are not found by searches...' 
#date >> /home/mlgb/sites/mlgb/parts/jobs/stripXMLcomments.log
python /home/mlgb/sites/mlgb/parts/jobs/stripXMLcomments.py >> /home/mlgb/sites/mlgb/parts/jobs/stripXMLcomments.log 2>&1

echo 'Stripping out unwanted formatting pasted from other websites...' 
#date >> /home/mlgb/sites/mlgb/parts/jobs/stripUnwantedFormatting.log
python /home/mlgb/sites/mlgb/parts/jobs/stripUnwantedFormatting.py >> /home/mlgb/sites/mlgb/parts/jobs/stripUnwantedFormatting.log 2>&1

echo 'Writing XML file for input into Solr catalogues index'
python /home/mlgb/sites/mlgb/parts/index/authortitle_to_xml.py > /home/mlgb/sites/mlgb/parts/jobs/authortitle_to_xml.log
echo ''

echo 'Writing PDF version of MLGB books data'
/home/mlgb/sites/mlgb/parts/jobs/write_pdf.sh > /home/mlgb/sites/mlgb/parts/jobs/write_pdf.log
echo ''


echo 'Rewriting static HTML for author/title index...' 
python writeHTML.py > /home/mlgb/sites/mlgb/parts/jobs/writeHTML.log 2>&1

echo 'Rewriting static HTML for list of medieval catalogues...' 
python cataloguesHTML.py > /home/mlgb/sites/mlgb/parts/jobs/cataloguesHTML.log 2>&1

echo 'Taking archive copy of images, then resizing for web display...' 
#date >> /home/mlgb/sites/mlgb/parts/jobs/process_photos.log 
/home/mlgb/sites/mlgb/parts/jobs/process_photos.sh >> /home/mlgb/sites/mlgb/parts/jobs/process_photos.log 2>&1

echo 'Reindexing Solr...'
curl http://127.0.1.1:1234/solr/books/dataimport?command=full-import > /home/mlgb/sites/mlgb/parts/jobs/solrimport.log 2>&1
curl http://127.0.1.1:1234/solr/catalogues/dataimport?command=full-import >> /home/mlgb/sites/mlgb/parts/jobs/solrimport.log 2>&1
