#!/bin/bash

BOOKS="elantris mistborn mistborn2 mistborn3 warbreaker alcatraz alloy"

declare -A URLS
declare -A TITLES
URLS[elantris]="http://brandonsanderson.com/annotation-elantris-introduction/"
TITLES[elantris]="Elantris Annotations"
URLS[mistborn]="http://www.brandonsanderson.com/annotation-mistborn-title-page-one/"
TITLES[mistborn]="Mistborn Annotations"
URLS[mistborn2]="http://brandonsanderson.com/annotation-mistborn-2-title-page/"
TITLES[mistborn2]="The Well of Ascension Annotations"
URLS[mistborn3]="http://brandonsanderson.com/annotation-mistborn-3-dedication/"
TITLES[mistborn3]="The Hero of Ages Annotations"
URLS[warbreaker]="http://brandonsanderson.com/annotation-warbreaker-dedication/"
TITLES[warbreaker]="Warbreaker Annotations"
URLS[alcatraz]="http://brandonsanderson.com/annotation-alcatraz-authors-foreword/"
TITLES[alcatraz]="Alcatraz vs. the Evil Librarians Annotations"
# for some reason, chapter 1 of Alloy is not available
URLS[alloy]="http://brandonsanderson.com/annotation-the-alloy-of-law-chapter-two/"
TITLES[alloy]="The Alloy of Law Annotations"

# need to check if requirements are satisfied
#   better to fail now than later
./check_requirements.py || { echo 'Requirements not satisfied'; exit 1; }

for book in $BOOKS; do
  url=${URLS[$book]}
  title=${TITLES[$book]}
  datadir="epub/${book}-data"
  epubdir="epub/${book}-annotations"

  echo "Creating annotations book for $book from $url"

  # Get data
  if [ ! -d $datadir ]; then
    mkdir -p $datadir
  fi
  ./get_book.py "$title" "Brandon Sanderson" "$url" "$datadir" || { echo 'Failed to get book data'; exit 1; }
  echo ""

  # Create book
  rm -rf $epubdir
  rm -rf epub/${book}*.epub
  mkdir -p $datadir
  echo "Creating ePub"
  ./gen_epub.py "$datadir" "$epubdir" || { echo 'Failed to generate book'; exit 1; }
  echo "Created"
done

