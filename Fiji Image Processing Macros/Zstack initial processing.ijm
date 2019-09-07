/*
 * Macro template to process multiple images in a folder of the czi format. Dont mess within unless you know what you are doing. 
 * Input:
 * input folder of image stacks in three channels, in Zayna's case ph, Phalodin, DAPI
 * Program will ask for input directory, then output, then suffix of the desired image files, default being tif, and a file pattern. For example, if one uses NULL
 * as the pattern, only images containing NULL will be processed. 
 *  * 
 *  
 * Each image will be extracted from the master image stacks, then have its Z projection take (only first channel, based on intensity). This image is then saved to the
 * output directory. 
 * 
 * 
 * Output:
 * In output folder, single z projected images will be saved with original image name. 
 * --Max Hockenberry 9 7 19
 * 
 * Copyright (C) <2019>  <Max Hockenberry>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".czi") suffix
#@ String(label = "Title contains") pattern

// See also Process_Folder.py for a version of this code
// in the Python scripting language.
//setBatchMode(true);
processFolder(input);
close("*");
processFolder2(output);

//setBatchMode(false);
// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Processing: " + input + File.separator + file);
	print("Saving to: " + output);
	print(input + "\\" + file);
	run("Bio-Formats Importer", "open=["+ input + "\\" + file +"] color_mode=Default open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	processOpenImages();
	//close();	
}

/*
 * Processes all open images. If an image matches the provided title
 * pattern, processImage() is executed.
 */
function processOpenImages() {
	n = nImages;
	//setBatchMode(true);
	for (i=1; i<=n; i++) {
		selectImage(i);
		imageTitle = getTitle();
		imageId = getImageID();
		if (matches(imageTitle, "(.*)"+pattern+"(.*)"))
			processImage(imageTitle, imageId, output);
	}
	//setBatchMode(false);
}

/*
 * Processes the currently active image. Use imageId parameter
 * to re-select the input image during processing.
 */
function processImage(imageTitle, imageId, output) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Processing: " + imageTitle);
	pathToOutputFile = output + File.separator + imageTitle + ".png";
	print("Saving to: " + pathToOutputFile);
	run("Z Project...", "projection=[Max Intensity]");
	close("MAX", "keep");
	//run("Split Channels");
	print(output + imageTitle);
	saveAs("Tiff", output + "\\" + imageTitle);
	close();
}










function processFolder2(input) {
	list = getFileList(input);
	suffix2 = ".tif";
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix2))
			processFile2(input, output, list[i]);
	}
}

function processFile2(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Processing: " + input + File.separator + file);
	print("Saving to: " + output);
	//print(input + "\\" + file);
	run("Bio-Formats Importer", "open=["+ input + "\\" + file +"] color_mode=Default open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	run("Slice Keeper", "first=1 last=1 increment=1");
	saveAs("Tiff", output + "\\" + file);
	close();
	close();	
}