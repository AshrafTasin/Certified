// import { createRequire } from 'module';
// const require = createRequire(import.meta.url);


// const fs=require('fs');

//import { writeFile } from 'fs-web';

var img64string,name,reg,dept,school,year,cgpa,grade,distinction;


var studnetnew;
// img64string=cgpa=name=undefined;

var student= function( name, cgpa, img64string,reg,dept,school,year,grade,distinction){

       
    this.name=name;
    this.cgpa=cgpa;
    this.img=img64string;
    this.reg=reg;
    this.dept=dept;
    this.school=school;
    this.year=year;
    this.grade=grade;
    this.distinction=distinction;

}
function getRegNo(){

   reg=document.getElementById("std_reg").value;
}
function getGrade(){

   grade=document.getElementById("std_grade").value;
}
function getDistin(){

   distinction=document.getElementById("std_dist").value;
}
function getSchool(){

   school=document.getElementById("std_school").value;
}
function getCyear(){

   year=document.getElementById("std_cyear").value;
}
function getDept(){

   dept=document.getElementById("std_dept").value;
}
function getName(){

  named=document.getElementById("std_name").value;
  //console.log(named)

}
function getCG(){

  cgpa=document.getElementById("std_cg").value;

  if( cgpa<2.00 || cgpa>4.01 || isNaN(cgpa )){

    window.alert (" Minimum CGPA: 2.00 \n"+"Maximum CGPA :4.00");
    document.getElementById("std_cg").value=2.00
    cgpa=undefined;
    return;
  }
 // console.log(cgpa);
}
function checkData(){
 
   
  console.log("Select was clicked");
   if (name==undefined|| cgpa==undefined || img64string==undefined
    || reg==undefined ||school==undefined || grade==undefined 
    || dept==undefined 
    )
    {

   console.log( name + "1 "+ cgpa + "2 "+ reg + "3" + school + "4" + grade+"5" +  dept)
    window.alert("Fullfill properly");
    location.replace("index.html")
     return;
   }
   
   var studnetnew= new student(name,cgpa,img64string,reg,dept,school,year,grade,distinction) ;
   let dataJSON= JSON.stringify( studnetnew );
   console.log(dataJSON);
   location.replace("index.html")
   
  // writeFile('student.json',dataJSON);
  // fs.writeFileSync('student.json',dataJSON);


}
function previewFile() {
    const preview = document.querySelector('img');
    const file = document.querySelector('input[type=file]').files[0];
    const reader = new FileReader();
  
    reader.addEventListener("load", function () {
      // convert image file to base64 string
      preview.src = reader.result;
    
      img64string=preview.src///JSON.stringify(preview.src);
      
      console.log(img64string);

    }, false);
  
    if (file) {
      reader.readAsDataURL(file);
    }
  }


// const getfile=document.getElementById('choose_file');
// import { createRequire } from 'module';
// const require = createRequire(import.meta.url);

// var x;
// getfile.addEventListener("change", (event)=>{
   
//     const fileList= event.target.files[0];

//     var path = (window.URL || window.webkitURL).createObjectURL(fileList)
//     FileReader f=new FileReader();
//     console.log( fileList.getfile);
//     console.log( path);
//     x=path;
     
// });

// const fs = require('fs');
// let pdfParser = new PDFParser();
// PDFParser = require("pdf2json");

// pdfParser.on("pdfParser_dataError", errData => console.error(errData.parserError) );
// pdfParser.on("pdfParser_dataReady", pdfData => {

//     console.log(pdfData.URL.stringify());
// fs.writeFile("./F1040EZ.json", JSON.stringify(pdfData));
// });

// pdfParser.loadPDF(x);
