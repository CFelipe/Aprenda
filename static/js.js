jQuery(function ($) {
    $('[rel=tooltip]').tooltip()
});

regusuario = $("#registroform input[name='nomeusuario']");
regemail = $("#registroform input[name='email']");

regusuario.blur(function(e) {
    $.getJSON($SCRIPT_ROOT + '/_proc_usuario', {
        nomeusuario: regusuario.val()
    }, function(data) {
        if(!data['nomeusuario']) {
            regusuario.parent().addClass("has-error")
        } else {
            regusuario.parent().removeClass("has-error")
        }
    });
});

regemail.blur(function(e) {
    $.getJSON($SCRIPT_ROOT + '/_proc_usuario', {
        email: regemail.val()
    }, function(data) {
        if(!data['email']) {
            regemail.parent().addClass("has-error")
        } else {
            regemail.parent().removeClass("has-error")
        }
    });
});
