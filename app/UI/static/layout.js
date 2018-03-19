function openCloseLoginMenu() {
    $("#loginMenu").click(function () {
        toggleClass('');
    });
}


function formValidate() {
    var elements = document.getElementById("#user-signup-form").elements;

    for (var i = 0, element; element = elements[i++];) {
        if (element.type === "text" && element.value === "")
            alert("it's an empty textfield");
    }

    var pass1 = document.getElementById("#password").value;
    var pass2 = document.getElementById("#password_confirmation").value;
    var ok = true;
    if (pass1 != pass2) {
        //alert("Passwords Do not match");
        document.getElementById("pass1").style.borderColor = "#E34234";
        document.getElementById("pass2").style.borderColor = "#E34234";
        ok = false;
    }
    else {
        alert("Passwords Match!!!");
    }
    return ok;

}

$(document).ready(function () {

    openCloseLoginMenu();

    $("#sign-up-us").click(function () {
        document.getElementById('sign-up-form').style.visibility = 'visible'
    });

});









