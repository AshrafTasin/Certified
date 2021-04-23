


var name,pass;

function signinOnClick(){


    name=document.getElementById("adminname").value;
    pass=document.getElementById("adminpass").value;

    console.log( name +" ========={ " + pass);
    

    if( name=="joydip" && pass=="1234"){

        console.log(" WOW 1 2 3 4 ")
        location.replace("index.html")
    }
    else{

        alert("mismatch info");
    }
    

}