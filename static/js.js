jQuery(function ($) {
    $('[rel=tooltip]').tooltip() 
});

$( "#linkf" ).focus(function() {
    $(".helpcontent").text("Olá mundo")
});