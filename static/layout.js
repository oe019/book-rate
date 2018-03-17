
function openLoginToggle() {
    $("#loginMenu").toggleClass('dropdown open');
}


$(document).ready(function () {

   openLoginToggle();

    $("#loginMenu").click(function () {
         openLoginToggle();
    });

});

$(document).read(function () {
        $("#search-box-form").style.visibility ='hidden';
});

