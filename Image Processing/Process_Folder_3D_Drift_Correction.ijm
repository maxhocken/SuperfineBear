/*
 * Macro template to process multiple images in a folder
 * going to run the 3D drift on a whole folder using the best settings
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
	outputpath = outputdir; 
	//+ "\\" + imgname;

	//open the file
	//open(samplename);
	filepath = samplename + "\\" + imgname;
	print(filepath);
	run("Bio-Formats Importer", "open=[filepath] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	run("Correct 3D drift", "channel=2 multi_time_scale sub_pixel edge_enhance only=0 lowest=1 highest=1");
	selectWindow("registered time points");
	
	saveAs("Tiff", outputpath + "\\" + imgname);
	close("*");


	
}



function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Processing: " + input + File.separator + file);
	action(input,output,file);
	print("Saving to: " + output);
}
