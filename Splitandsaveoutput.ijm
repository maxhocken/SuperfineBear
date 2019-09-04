samplename = getString("prompt", "default") //ask user for sample name
imgname=getTitle()
outputdir = getDirectory("_Choose output Directory"); //Choose an output directory for the files
File.makeDirectory(outputdir + "ph")
File.makeDirectory(outputdir + "rfp")
File.makeDirectory(outputdir + "gfp")
saveAs("Tiff", outputdir + samplename);

function action(samplename, outputdir, imgname) {
	run("Split Channels");
	selectWindow("C1-" +samplename+".tif");
	i = "C1-" +samplename
	run("Image Sequence... ", "format=TIFF name=i start=0 digits=3 save=["+ outputdir + "ph" +"]");
	close()
	selectWindow("C2-" +samplename+".tif");
	j = "C2-" +samplename
	run("Image Sequence... ", "format=TIFF name=samplename start=0 digits=3 save=["+ outputdir + "rfp" +"]");
	close()
	selectWindow("C3-" +samplename+".tif");
	k = "C3-" +samplename
	run("Image Sequence... ", "format=TIFF name=k start=0 digits=3 save=["+ outputdir + "gfp" +"]");
	close()
	
}

//setBatchMode(true); 

action(samplename,outputdir,imgname)

//setBatchMode(false);
