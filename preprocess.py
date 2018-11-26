#!/usr/bin/pythonX
# -*- coding: UTF-8 -*-

import os
import shutil

folder_path = '/Users/zhaxu/Downloads/raw-img'
training_folder_path = folder_path + '/../training'
testing_folder_path = folder_path + '/../testing'


def make_dir_if_needed(path):
	if not path:
		return
	if not os.path.exists(path):
		os.makedirs(path)

make_dir_if_needed(training_folder_path)
make_dir_if_needed(testing_folder_path)

for dir in os.listdir(folder_path):
	
	category_folder_path = folder_path + '/' + dir
	if not os.path.isdir(category_folder_path):
		continue

	print('Preprocess ' + dir + '...')
	training_category_folder_path = training_folder_path + '/' + dir
	testing_category_folder_path = testing_folder_path + '/' + dir

	all_files = os.listdir(category_folder_path)
	count = 0
	total_count = len(all_files)
	threhold = total_count * 0.7

	make_dir_if_needed(training_category_folder_path)
	make_dir_if_needed(testing_category_folder_path)

	for img in all_files:
		count = count + 1
		src = category_folder_path + '/' + img
		if count < threhold:
			shutil.copy2(src, training_category_folder_path + '/' + img)
		else:
			shutil.copy2(src, testing_category_folder_path + '/' + img)
		

