
var form = document.getElementById('logout')

form.addEventListener('submit',logOut)


async function logOut(){

    event.preventDefault()
    
    const result = await fetch('/logout'
    ,{
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        }

    })
    .then((res) => res.json())

    // console.log(JSON.parse(result))

    console.log(result.result)

    if (result.success) {

        alert('Success')
        localStorage.removeItem('token')
        location.replace("/login")
    } else {
        alert(result.result)
    }
}