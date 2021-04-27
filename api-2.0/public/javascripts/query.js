
var form = document.getElementById('query_form')
var channel,chaincode,reg,user,org
form.addEventListener('submit',queryData)


async function queryData(){

    event.preventDefault()

   
    channel=document.getElementById('channel_name').value
    chaincode=document.getElementById('chaincode_name').value
    user=document.getElementById('user_name').value
    org=document.getElementById('org_name').value
    reg=document.getElementById('reg').value
    
    let url = '/query' +'?' + new URLSearchParams({

        channelName :channel,
        chaincodeName : chaincode,
        args : reg,
        fcn : 'queryStudent',
        username : user,
        orgname : org

    });

    console.log(url);

    // const result = await fetch( url,
    // {
    //     method: 'GET',
    //     headers: {
    //         'Content-Type': 'application/json',
    //     }

    // })
    // // .then((res) => res.json())
    
    // let data = await result.text();
    // console.log(data);

    window.location.href = url ;

    // if(result.error == null){
    //     location.assign('/result')
    // }

}