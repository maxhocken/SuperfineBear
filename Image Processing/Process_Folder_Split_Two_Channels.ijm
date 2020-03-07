/*
 * Macro to split all files in folder into two channels, base of phase contrast and rfp.
 * 
 * Input:
 * input folder of image stacks in two channels, 1 ph, 2 rfp
 * Program will ask for input directory, then output, then suffix of the desired image files, default being tif. 
 *  * 
 * Output:
 * folders of each image stack with original image, then two sub folders with image sequence of each ph, and rfp. 
 
 * We find that trying to save files in the same folder leads to saving IOexceptions. Make sure output and input folders are not inside each other
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
#@ String (label = "File suffix", value = ".tif") suffix

// See also Process_Folder.py for a version of this code
// in the Python scripting language.
setBatchMode(true)
processFolder(input);
setBatchMode(false)
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

function action(samplename, outputdir, imgname) {
	
	//samplename = getString("prompt", "default"); //ask user for sample name
	//imgname=getTitle()
	outputpath = outputdir + "\\" + imgname;
	test = outputpath + "\\" + "php";
	//print(test);
	//print(outputpath);
	File.makeDirectory(outputpath)
	File.makeDirectory(outputpath + "\\" + "ph")
	File.makeDirectory(outputpath + "\\" + "rfp")
	
	//open the file
	//open(samplename);
	filepath = samplename + "\\" + imgname;
	print("here");
	print(filepath);
	run("Bio-Formats Importer", "open=[filepath] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	saveAs("Tiff", outputpath + "\\" + imgname);


	
	run("Split Channels");
	selectWindow("C1-" +imgname);
	i = "C1-" +imgname;
	resetMinAndMax();
	run("Apply LUT", "stack");
	run("Image Sequence... ", "format=TIFF name=i start=0 digits=3 save=["+ outputpath + "\\" +"ph" +"]");
	close();
	selectWindow("C2-" +imgname);
	j = "C2-" +imgname;
	resetMinAndMax();
	run("Apply LUT", "stack");
	run("Image Sequence... ", "format=TIFF name=j start=0 digits=3 save=["+ outputpath + "\\" + "rfp" +"]");
	close();
	
	
}



function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Processing: " + input + File.separator + file);
	action(input,output,file);
	print("Saving to: " + output);
}