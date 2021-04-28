// var img64string,names,reg,dept,school,year,cgpa,grade,distinction
var form = document.getElementById('login_form')
var userName,orgName;
form.addEventListener('submit',submitData)


async function submitData(){

    event.preventDefault()

    userName=document.getElementById('username').value;
    orgName=document.getElementById('orgname').value
    
    const result = await fetch('/login', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            userName,
            orgName
        })


    }).then((res) => res.json())


    if (result.success) {
        console.log(localStorage.getItem('token'))
        
        Swal.fire({
            icon: 'success',
            title: 'Login Successful!',
          }).then(()=>{
            if(orgName == "sust"){
              location.assign('index');
            }else if(orgName == "startech"){
              location.assign('dashboard');
            }
           
          })
        
    } else {

        Swal.fire({
            icon: 'error',
            title: 'Oops...',
            text: 'Something went wrong! Check Credentials Again!',
          }).then(()=>{
            location.assign('login');
          })
    }
}