// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require fileupload/jquery.ui.widget
//= require fileupload/jquery.iframe-transport
//= require fileupload/jquery.fileupload
//= require react
//= require react_ujs
//= require components
//= require lodash.core
//= require_tree .

function enableUploadLink(){
    var invalidInputs = $(".presentation-validate-content.invalid").length;
    var fileField = $("#presentation-file-field");

    if (invalidInputs == 0 && (fileField.length == 0 || fileField.val().length > 0))
        $("form#presentation .upload-btn").removeClass('disabled')
    else
        $("form#presentation .upload-btn").addClass('disabled')
}

$(document).ready(function() {
    $('.collapsible').collapsible();
    $('select').material_select();
    $('ul.tabs').tabs();
    $('input#presentation_title').characterCounter();
    $('#presentation_description').trigger('autoresize');

    $('.datepicker').pickadate({
        selectMonths: true, // Creates a dropdown to control month
        selectYears: 15, // Creates a dropdown of 15 years to control year
        format: 'dd mmm, yyyy',
        formatSubmit: 'yyyy-mm-dd',
        closeOnSelect: true
    });

    var chosen_option = {
        no_results_text: 'No results matched',
        width: '500px'
    };
    $('.chosen-select').chosen(chosen_option);
});

$(function() {
    $('form#presentation').on("change", ".presentation-validate-content", function() {
        var field = $(this);

        console.log(field.val());
        if (field.val().match(/<|>/) != null)
            field.addClass("invalid");
        else
            field.removeClass("invalid");

        enableUploadLink();
    });

    $(".presentation-validate-content").change();
    $('.presentation_upload_form').fileupload({
        dataType: 'json',
        replaceFileInput: false,
        url: $('.presentation_upload_form').attr('action'),
        add: function (e, data) {
            enableUploadLink();
            $(this).find('.file-path').removeClass('invalid');
            $(this).find('.upload-btn').click(function (e) {
                e.preventDefault();
                $(this).addClass('disabled');
                data.submit();
            });
        },
        progressall: function(e, data) {
            var progress = parseInt(data.loaded / data.total * 100, 10);
            $(this).find('.upload-progress-row').show();
            $(this).find('.determinate').css(
                'width',
                progress + '%'
            );
        },
        always: function (e, data) {
            $(this).find('.upload-progress-row').hide();
        },
        fail: function (e, data) {
            Materialize.toast(data.jqXHR.responseJSON.error, 10000);
            $(this).find('.file-path').addClass('invalid');
            $(this).find('.upload-btn').removeClass('disabled');
        },
        done: function (e, data) {
            $(this).find('.upload-btn').addClass('disabled');
            if ($('.presentation-new').length > 0) {
                window.location.href = "/presentations?status=notice&message=Upload+finished.";
            } else {
                $(this).find('.file-upload-row').hide();
                Materialize.toast('Upload finished.', 4000);
            }
        }
    });
});
