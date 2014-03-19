$(document).ready () ->
  $('.user_menu_buttons').on 'click', '.add_email_report', (evt) ->
    $.post('/emails/add_report', {
      id: $(this).attr('data-report')
    })
    evt.preventDefault()

  $('.user_menu_buttons').on 'click', '.remove_email_report', (evt) ->
    $.post('/emails/remove_report', {
      id: $(this).attr('data-report')
    })
    evt.preventDefault()

  $('#emails_cart').on 'click', '#review_emails_cart', (evt) ->
    $.post('/emails/review')
    evt.preventDefault()

  $('body').on 'click', '.editor_remove_report', (evt) ->
    $.post('/emails/remove_from_editor', {
        id: $(this).attr('data-report')
      })
    $(this).closest('tr').remove()
    evt.preventDefault()

  $('.email_checkbox').click (evt) ->
    evt.preventDefault()
    if this.checked
      $.post('/emails/add_report', {
        id: $(this).val()
      })
    else
      $.post('/emails/remove_report', {
        id: $(this).val()
      })