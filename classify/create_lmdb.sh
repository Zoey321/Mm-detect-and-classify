SAVE=examples/cell/group2_2h/1


echo "Create train lmdb.."
rm -rf $SAVE/img_train_lmdb
build/tools/convert_imageset --shuffle --resize_height=256 --resize_width=256 data/cell/Result2/10fold_2/1/ data/cell/Result2/10fold_2/1/trainlabel.txt $SAVE/img_train_lmdb

echo "Create test lmdb.."
rm -rf $SAVE/img_test_lmdb
build/tools/convert_imageset --shuffle --resize_width=256 --resize_height=256 data/cell/Result2/10fold_2/1/ data/cell/Result2/10fold_2/1/testlabel.txt $SAVE/img_test_lmdb

echo "Create val lmdb.."
rm -rf $SAVE/img_val_lmdb
build/tools/convert_imageset --shuffle --resize_width=256 --resize_height=256 data/cell/Result2/10fold_2/1/ data/cell/Result2/10fold_2/1/validationlabel.txt $SAVE/img_val_lmdb

echo "All Done.."

