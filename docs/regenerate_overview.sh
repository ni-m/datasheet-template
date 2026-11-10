pdftoppm -png -r 150 -l 4 ../build/example.pdf page
magick montage page-*.png -tile 4x1 -geometry +16+16 -bordercolor black -border 1 -background none -shadow overview.png
rm page-*.png
