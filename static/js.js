jQuery(function ($) {
    $('[rel=tooltip]').tooltip()
});

regusuario = $("#registroform input[name='nomeusuario']");
regemail = $("#registroform input[name='email']");

regusuario.focus(function(e) {
    regusuario.parent().removeClass("has-error")
    regusuario.popover('destroy')
});

regusuario.blur(function(e) {
    $.getJSON($SCRIPT_ROOT + '/_proc_usuario', {
        nomeusuario: regusuario.val()
    }, function(data) {
        if(!data['nomeusuario']) {
            regusuario.parent().addClass("has-error");
            regusuario.popover('show')
        } else {
            regusuario.parent().removeClass("has-error")
        }
    });
});

regemail.focus(function(e) {
    regemail.parent().removeClass("has-error")
    regemail.popover('destroy')
});

regemail.blur(function(e) {
    $.getJSON($SCRIPT_ROOT + '/_proc_usuario', {
        email: regemail.val()
    }, function(data) {
        if(!data['email']) {
            regemail.parent().addClass("has-error")
            regemail.popover('show', { container: 'body' })
        } else {
            regemail.parent().removeClass("has-error")
        }
    });
});
