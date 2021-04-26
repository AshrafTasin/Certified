
var form = document.getElementById('home_form')

form.addEventListener('submit',goBoard)


async function goBoard(){

    event.preventDefault()
    
    const result = await fetch('/index'
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
        location.replace("/index")
    } else {
        alert(result.result)
    }
}