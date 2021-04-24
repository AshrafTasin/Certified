var username,orgName
var form = document.getElementById('login_form')
form.addEventListener('submit',login)


async function login(event){

    event.preventDefault()
    username =document.getElementById("userName").value;
    orgName=document.getElementById("userOrg").value;
    
    const result = await fetch('/login', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            username,
            orgName
        })
    }).then((res) => res.json())

    if (result.success) {
        // everythign went fine
        console.log('Got the token: ', result.message.token)
        localStorage.setItem('token', result.message.token)
        alert('Success')
        location.replace("home.html")

    } else {
        alert(result.message)
    }
    

}