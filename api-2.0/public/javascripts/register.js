
var form = document.getElementById('registration_form')
var username,orgName;
form.addEventListener('submit',submitData)


async function submitData(){

    event.preventDefault()

    username=document.getElementById('username').value;
    
    orgName=document.getElementById('orgname').value
    
    const result = await fetch('/register', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            username,
            orgName
        })


    }).then((res) => res.json())

    // console.log(JSON.parse(result))

    if (result.success) {
        console.log(localStorage.getItem('token'))
        
        Swal.fire({
            icon: 'success',
            title: 'Registration Successful! This User can login now',
          }).then(()=>{
            location.assign('login');
          })
        
    } else {

        Swal.fire({
            icon: 'error',
            title: 'Oops...',
            text: 'Something went wrong!',
          }).then(()=>{
            location.assign('register');
          })
    }
}