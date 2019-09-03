/*
 * Macro to split all files in folder into channels
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
	File.makeDirectory(outputpath + "\\" + "gfp")
	//open the file
	//open(samplename);
	filepath = samplename + "\\" + imgname;
	print(filepath);
	run("Bio-Formats Importer", "open=[filepath] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	saveAs("Tiff", outputpath + "\\" + imgname);


	
	run("Split Channels");
	selectWindow("C1-" +imgname);
	i = "C1-" +imgname;
	run("Image Sequence... ", "format=TIFF name=i start=0 digits=3 save=["+ outputpath + "\\" +"ph" +"]");
	close();
	selectWindow("C2-" +imgname);
	j = "C2-" +imgname;
	run("Image Sequence... ", "format=TIFF name=j start=0 digits=3 save=["+ outputpath + "\\" + "gfp" +"]");
	close();
	selectWindow("C3-" +imgname);
	k = "C3-" +imgname;
	run("Image Sequence... ", "format=TIFF name=k start=0 digits=3 save=["+ outputpath + "\\" + "rfp" +"]");
	close();
	
}



function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Processing: " + input + File.separator + file);
	action(input,output,file);
	print("Saving to: " + output);
}