jQuery(function ($) {
    $('[rel=tooltip]').tooltip() 
});

$( "#linkf" ).focus(function() {
    $(".helpcontent").text("Olá mundo")
});

$("#loginform").submit(function(e) {
    $.ajax({
        type: "POST",
        url: "/login",
        data: { name: "John", location: "Boston" }
    })
    .done(function( msg ) {
        alert( "Data Saved: " + msg );
    });
    $.getJSON($SCRIPT_ROOT + '/login', {
        username: $('input[name="username"]').val()
    }, function(data) {
        alert(data.result)
    });
});