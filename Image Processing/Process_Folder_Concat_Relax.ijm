/*
 * Macro to concatenate two files together corresponding to appopriate directories. Used to concatenate sample files with relaxed state.
Input:
 * input folder of image stacks in three channels, 1 ph, 2 gfp, 3 rfp
 * Program will ask for input directory, relaxed input directory, then output, then suffix of the desired image files, default being tif. 
 *  * 
 * Output:
 * folders of each image with the relaxed state concatenated onto the sample in the output directory in the tif format. 
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
#@ File (label = "Relaxed directory", style = "directory") relax
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

// See also Process_Folder.py for a version of this code
// in the Python scripting language.
setBatchMode(true)
processFolder(input);
setBatchMode(false)
// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	listrelax = getFileList(relax);
	list = Array.sort(list);
	listrelax = Array.sort(listrelax);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i], relax, listrelax[i]);
	}
}




function processFile(input, output, file, relaxdir, relaxname) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Processing: " + input + File.separator + file);
	action(input,output,file, relaxdir, relaxname);
	print("Saving to: " + output);
}



function action(samplename, outputdir, imgname, relaxedir, relaxname) {
	
	
	samplefilepath = samplename + "\\" + imgname;
	print(samplefilepath);
	relaxfilepath = relaxedir + "\\" + relaxname;
	print(relaxfilepath);
	//print(filepath); + "\\" + imgname;
	run("Bio-Formats Importer", "open=[samplefilepath] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	run("Bio-Formats Importer", "open=[relaxfilepath] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	
	run("Concatenate...", "  title=samplename open image1=[imgname] image2=[relaxname]");

	
	saveAs("Tiff", outputdir + "\\" + imgname);
	close();
}

