function collectSelectedThreadsId() {
    var ids = ""
    $(".message-threads-row-selector").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).attr("thread_id") + ","
        }
    });
    ids = ids.substr(0, ids.length - 1)
    return ids
}
function changeThreadStatus(source, status) {
    $.ajax({
        url:$(source).attr("href"),
        data:{
            ids:collectSelectedThreadsId(),
            status:status
        },
        success:function (resp) {
            $("#message_threads_table").html(resp);
            refreshComponents();
        }
    });
}
$(document).ready(function () {
    $(".message-threads-select-all").click(function () {
        if ($(".sss-checkbox", ".message-threads-select-all").hasClass('sss-checkbox-checked')) {
            $('.sss-checkbox', "#message_threads_table").each(function () {
                if (!$(this).hasClass('sss-checkbox-checked')) {
                    $(this).trigger('click');
                }
            });
        } else {
            $('.sss-checkbox', "#message_threads_table").each(function () {
                if (!$(this).hasClass('sss-checkbox-unchecked')) {
                    $(this).trigger('click');
                }
            });
        }

    });
    $(document).delegate('.filter_checkbox', 'click', function () {
        if ($(".sss-checkbox-checked", "#message_threads_table").length > 0) {
            $("#delete_selected_threads").removeClass('hidden');
            $("#message_threads_more_option_container").removeClass('hidden');
        } else {
            $("#delete_selected_threads").addClass('hidden');
            $("#message_threads_more_option_container").addClass('hidden');
        }
    });
    $("#message_threads_more_option").click(function () {
        $("#message_thread_more_options").slideToggle();
        $(this).toggleClass('open');
    });
    $("#delete_selected_threads").click(function () {
        $.ajax({
            url:$(this).attr("href"),
            data:{
                ids:collectSelectedThreadsId()
            },
            success:function (resp) {
                $("#message_threads_table").html(resp);
                refreshComponents();
            }
        });
        return false;
    });
    $("#mark_selected_threads_as_unread").click(function () {
        changeThreadStatus($(this), "UNREAD");
        return false;
    });
    $("#mark_selected_threads_as_read").click(function () {
        changeThreadStatus($(this), "READ");
        return false;
    });

})
function refreshComponents() {
    $('.sss-chb', "#message_threads_table").sssCheckbox();
    $("#delete_selected_threads").addClass('hidden');
    $("#message_threads_more_option_container").addClass('hidden');
    if ($(".sss-checkbox", ".message-threads-select-all").hasClass('sss-checkbox-checked')) {
        var _self = $(".sss-checkbox", ".message-threads-select-all");
        $(_self).addClass('sss-checkbox-unchecked');
        $(_self).removeClass('sss-checkbox-checked');
    }
}