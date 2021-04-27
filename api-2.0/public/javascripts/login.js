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

    // console.log(JSON.parse(result))

    if (result.success) {
        console.log(localStorage.getItem('token'))
        location.assign('home');
    } else {
        alert(result.result)
    }
}