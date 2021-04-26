const { User } = require("fabric-common")

// var img64string,names,reg,dept,school,year,cgpa,grade,distinction
var form = document.getElementById('query_form')
var reg
form.addEventListener('submit',submitData)


async function submitData(){

    event.preventDefault()

   
    reg=document.getElementById('reg').value
    
    const result = await fetch('/query' +'?' + new URLSearchParams({

        channelName :'channelbeta',
        chaincodeName : 'smartcert',
        args :'2017331014',
        fcn : 'getStudentHistory',
        username : 't1',
        orgname : 'sust'

    }),  
    {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        }

    })
    .then((res) => res.json())

    // console.log(JSON.parse(result))

    console.log(result.result)

    // if (result.success) {

    //     alert('Success')
    //     localStorage.setItem('token', 'Bearer '+result.message.token)
    //     location.replace("/index")
    // } else {
    //     alert(result.result)
    // }
}