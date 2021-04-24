var img64string,names,reg,dept,school,year,cgpa,grade,distinction

var form = document.getElementById('std_info_form')
// form.addEventListener('submit',submitData)


// async function getRegNo(){

//    reg=document.getElementById('std_reg').value;
//    console.log(reg)
// }
// async function getGrade(){

//    grade=document.getElementById('std_grade').value;
//    console.log(grade)

// }
// async function getDistin(){

//    distinction=document.getElementById('std_dist').value;
//    console.log(distinction)

// }
// async function getSchool(){

//    school=document.getElementById('std_school').value;
//    console.log(school)

// }
// async function getCyear(){

//    year=document.getElementById('std_cyear').value;
//    console.log(year)
// }
// async function getDept(){

//    dept=document.getElementById('std_dept').value;
//    console.log(dept)

// }
// async function getName(){

//   names=document.getElementById('std_name').value;
//   console.log(names)

// }
// async function getCG(){

//   cgpa=document.getElementById('std_cg').value;

//   if( cgpa<2.00 || cgpa>4.01 || isNaN(cgpa )){

//     window.alert (" Minimum CGPA: 2.00 \n"+"Maximum CGPA :4.00");
//     // document.getElementById('std_cg').value=2.00
//     cgpa=undefined;
//     return;
//   }
//   console.log(cgpa);
// }

// async function checkData(){
 
   
//   console.log("Select was clicked");
//    if (names==undefined|| cgpa==undefined || img64string==undefined
//     || reg==undefined ||school==undefined || grade==undefined 
//     || dept==undefined 
//     )
//     {

//    console.log( names + "1 "+ cgpa + "2 "+ reg + "3" + school + "4" + grade+"5" +  dept)
//     window.alert("Fullfill properly");
//     location.replace("home.html")
//      return;
//    }
   
//   //  var studnetnew= new student(names,cgpa,img64string,reg,dept,school,year,grade,distinction) ;
//   //  let dataJSON= JSON.stringify( studnetnew );
//   //  console.log(dataJSON);
//   //  location.replace("home.html")
   
//   // writeFile('student.json',dataJSON);
//   // fs.writeFileSync('student.json',dataJSON);
//   console.log("ALL OK")


// }

async function previewFile() {
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


async function submitData(){

    // event.preventDefault()

    names=document.getElementById('std_name').value;
    reg=document.getElementById('std_reg').value;
    dept=document.getElementById('std_dept').value;
    school=document.getElementById('std_school').value;
    year=document.getElementById('std_cyear').value;
    cgpa=document.getElementById('std_cg').value;
    grade=document.getElementById('std_grade').value;
    distinction=document.getElementById('std_dist').value;

    var args=[names,reg,dept,school,year,cgpa,grade,distinction,img64string]

    console.log(names + " " + reg + " " +dept+ " " +school+ " " +year + " " +cgpa + " " +grade+ " " +distinction + " " )
    console.log(args)
    console.log( localStorage.getItem('token') )
    console.log("DOne")
    const result = await fetch('/invoke', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + localStorage.getItem('token')
        },
        body: JSON.stringify({
           args
        })
    }).then((res) => res.json())

    console.log(result)

    if (result.result === "Success") {

        alert('Success')
        location.replace("home.html")
    } else {
        alert(result.result)
    }
}