//= require active_admin/base
//= require active_admin/searchable_select
 //= require active_admin_sidebar

$(document).ready(function () {
  $('.modal-link').click(function (event) {
      event.stopPropagation(); // prevent Rails UJS click event
      event.preventDefault();

      var link = $(event.target);
      var title = link.data('confirm') || link.text();
      var inputs = link.data('inputs');

      $('body').trigger('modal-link:before_open', [title, link]);

      ActiveAdmin.modal_dialog(title, inputs, function (payload) {
        var form = $('form#dialog_confirm');
        $('body').trigger('modal-link:submit', [title, payload, form, link]);
      });

      setTimeout(function (){
        var form = $('form#dialog_confirm');

        // increase dialog size
        form.closest('.ui-dialog').css({left: '30%', width: '40%'});

        // set form action and method
        form.attr('action', link.attr('href'));
        form.attr('method', 'post');

        // append csrf token and method
        form.append(
          $('<input>', { type: 'hidden', name: $.rails.csrfParam(), value: $.rails.csrfToken() }, [])
        );
        form.append(
          $('<input>', { type: 'hidden', name: '_method', value: link.data('method') }, [])
        );

        $('body').trigger('modal-link:after_open', [title, form, link]);
      }, 0);
    });

  $('body').on('modal-link:submit', function (event, title, payload, form, link) {
      form[0].submit();
  })
});
