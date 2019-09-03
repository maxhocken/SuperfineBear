//input1 = "/home/Max/desktop/norm/"; //images
//input2 = "/home/Max/desktop/relaxed/"; //relaxed state
//output = "/home/Max/desktop/output/";

input1 = getDirectory("Choose sample Directory"); //images
input2 = getDirectory("_Choose relaxed Directory"); //relaxed state
output = getDirectory("_Choose output Directory");

//function to concatenate input 2 to input 1
function action(input1, input2, output, filename1, filename2) {
        //open(input1 + filename1); wont work with .ids files
        //open(input2 + filename2);
        if (indexOf(filename1,".ids") >= 0) {
        	run("Bio-Formats Importer", "open=["+ input1 + filename1 +"]");
        	run("Bio-Formats Importer", "open=["+ input2 + filename2 +"]");

        
        	//run("Bio-Formats Importer", "open=[input1]");
        	//run("Bio-Formats Importer", "open=[input2]");
        	//print("Processing: " + input1 + filename1)
        	//img1=
        	//img2=
        	run("Concatenate...", "  title=["+ filename1 +"] open image1=["+ filename1 +"] image2=["+ filename2 +"]");
			saveAs("Tiff", output + filename1);
        	close();
        }

        
        //run("Bio-Formats Importer", "open=["+ input1 + filename1 +"]");
        //run("Bio-Formats Importer", "open=["+ input2 + filename2 +"]");

        
        //run("Bio-Formats Importer", "open=[input1]");
        //run("Bio-Formats Importer", "open=[input2]");
        //print("Processing: " + input1 + filename1)
        //run("Concatenate...", "  title=["filename1"] open image1=["filename1"] image2=["filename2"]");
		//saveAs("Tiff", output + filename1);
        //close();
}

setBatchMode(true); 
list1 = getFileList(input1);
//print( "list1" );
list2 = getFileList(input2);
//print( "list2" );
for (i = 0; i < list1.length; i++)
        action(input1, input2, output, list1[i], list2[i]);
        //print(list1[i])
setBatchMode(false);