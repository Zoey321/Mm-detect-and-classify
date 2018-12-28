SAVE=examples/cell/fp


echo "Create train lmdb.."
rm -rf $SAVE/img_train_lmdb
build/tools/convert_imageset --shuffle --resize_height=256 --resize_width=256 data/cell/caffeFP/FData/ data/cell/caffeFP/FData/trainlabel.txt $SAVE/img_train_lmdb

#echo "Create test lmdb.."
#rm -rf $SAVE/img_test_lmdb
#build/tools/convert_imageset --shuffle --resize_width=256 --resize_height=256 data/cell/caffeFP/ data/cell/caffeFP/testlabel.txt $SAVE/img_test_lmdb

echo "Create val lmdb.."
rm -rf $SAVE/img_val_lmdb
build/tools/convert_imageset --shuffle --resize_width=256 --resize_height=256 data/cell/caffeFP/FData/ data/cell/caffeFP/FData/validationlabel.txt $SAVE/img_val_lmdb

echo "All Done.."

