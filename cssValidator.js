$(document).ready(function () {

    //remove invalid class when value in input change
    $('input').change(function () {
        if ($("#" + $(this).attr('id')).hasClass('is-invalid'))
            $("#" + $(this).attr('id')).removeClass('is-invalid');
    });

    $('input').keypress(function () {
        if (($("#" + $(this).attr('id')).hasClass('is-invalid')))
            $("#" + $(this).attr('id')).removeClass('is-invalid');
    });

    //for adding code after page validation
    var originalValidationFunction = Page_ClientValidate;
    if (originalValidationFunction && typeof (originalValidationFunction) == "function") {
        Page_ClientValidate = function (validationGroup) {
            originalValidationFunction(validationGroup);

            //after page validation, if page is invalid 
            if (!Page_IsValid) {
                if (originalValidationFunction && typeof (Page_Validators) == "undefined")
                    return;
                else {
                    //for each FieldValidator, if FieldValidator is invalid, add 'is-invalid' class to input tag
                    $.each(Page_Validators, function (i, val) {
                        val = Page_Validators[i];
                        //console.log(val);
                        if (val.isvalid == false) {
                            var inputID = $(val).attr('id').slice(0, $(val).attr('id').length - 5);     //FieldValidator ID is "inputID + error", removes 'error' to get inputID
                            $('#' + inputID).addClass('is-invalid');
                        }
                    });
                }
            }
        };
    }

});
