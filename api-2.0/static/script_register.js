var username,orgName
var form = document.getElementById('reg_form')
form.addEventListener('submit',register)


async function register(event){

    event.preventDefault()
    username =document.getElementById("adminname").value;
    orgName=document.getElementById("adminpass").value;


    const result = await fetch('/register', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            username,
            orgName
        })
    }).then((res) => res.json())

    console.log(result)

    if (result.success) {

        alert('Success. Please Log in now')
        location.replace("login.html")
    } else {
        alert(result.message)
    }
}