
function openCloseLoginMenu() {
  $("#loginMenu").click(function () {
         toggleClass('');
    });
}


$(document).ready(function () {

   openCloseLoginMenu()

   $("#sign-up-us").click(function () {

       alert('alert!!')

       document.getElementById('sign-up-form').style.visibility = 'visible'

   }) ;

});









