// var img64string,names,reg,dept,school,year,cgpa,grade,distinction
var form = document.getElementById('home_form')
form.addEventListener('submit',goBoard)


async function goBoard(){

    event.preventDefault()

    const result = await fetch('/index', {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        }
    })

    location.assign('index');
}