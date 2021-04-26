// var img64string,names,reg,dept,school,year,cgpa,grade,distinction
var form = document.getElementById('redirect')

form.addEventListener('submit',submitData)


async function submitData(){

    event.preventDefault()
    
    fetch('/login', {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': localStorage.getItem('token')
        },
    })
}