


var studentname,cgpa,subjuct,year,lettergrade,school;

///get data from db first and assign  fetched values to variable
studentname="getFromDataBase"
cgpa="3.75"
subjuct="Oceanology"
year="2030"
school="getFromDatabase"
lettergrade="DB"


 document.getElementById("name").value = studentname;
 document.getElementById("subject_name").value = subjuct;
 document.getElementById("school_name").value = school;
 document.getElementById("subject_cgpa").value = cgpa;
 document.getElementById("subject_letter_grade").value = lettergrade;
 document.getElementById("subject_year").value = year;


console.log(cgpa);

// console.log( " it works "+ cgpa);

