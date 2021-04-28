var img64string,names,reg,dept,school,year,cgpa,grade,distinction

var form = document.getElementById('std_info_form')
form.addEventListener('submit',submitData)


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

    event.preventDefault()

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
    console.log("Done")

    if (names==undefined|| reg==undefined || dept==undefined|| school==undefined || 
      year==undefined || cgpa ==undefined || grade ==undefined || distinction==undefined || 
      img64string==undefined){
        Swal.fire({
          icon: 'error',
          title: 'Fulfill Properly',
        })
       return;
     }
    
    const result = await fetch('/invoke', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': localStorage.getItem('token')
        },
        body: JSON.stringify({
           args
        })
    }).then((res) => res.json())

    console.log(result)

    if (result.error == null) {

        Swal.fire({
            icon: 'success',
            title: 'Student Info Uploaded to Blockchain',
          }).then(()=>{
            location.replace('index');
          })
    } else {
        alert(result.result)
    }
}