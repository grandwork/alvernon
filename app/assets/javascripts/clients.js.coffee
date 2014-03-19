window.remove_email = (link) ->   
  $(link).parents('.row-fluid').first().fadeOut('fast')
  $(link).parents('.row-fluid').first().remove()

window.add_email_field = (link, html) ->
  $(html).insertBefore($(link).parents('.control-group').first())

$ ->
  show_suggestions = (form, data, client) ->
    $('#modal_header').text('Submitting report')
    $('#modal_submit').text('Continue')
    if client == ''
      $('#modal_body').html('<p>You did not specify client for this report. Do you want to continue anyway?</p>')
      $('#modal_submit').click (e) ->
        form.unbind('submit')
        form.submit()
    else
      if data == false
        $('#modal_body').html('<p>There is no ' + client + ' client in the database.</p><p>Would you like to add ' + client + ' as a new client?</p>')
        $('#modal_submit').click (e) ->
          form.unbind('submit')
          form.submit()
      else if data != true
        $('#modal_body').html('<p>There is a similar client in the database. ' + 'Would you like to set client to <strong>' + data[0][0] + '</strong> instead of ' + client + '?</p>')
        $('#modal_submit').text('Yes, change to ' + data[0][0])
        $('<a href="#" class="btn btn-danger" id="keep_client">No, keep current client</a>').insertBefore('#modal_submit')
        $('#modal_submit').click (e) ->
          $('.client-input').val(data[0][0])
          e.preventDefault()
          form.unbind()
          form.submit()
        $('#keep_client').click (e) ->
          e.preventDefault()
          form.unbind('submit')
          form.submit()
    $('#modal_close').text('Cancel')
    $('#modal').modal('show')

  show_address_changed = (form, old, address) ->
    $('#modal_header').text('Submitting report')
    $('#modal_submit').text('Update address & save report')
    $('#modal_body').html('<p>You have changed ' + old.title + ' address.</p><p>Their current address is</p><pre>' + old.notes + '</pre><p>The address set in this report is</p><pre>' + address + '</pre><p>You can update their address in the database, or keep the new address only in this report.')
    $('#modal_submit').click (e) ->
      e.preventDefault(e)
      $('#update_client_address').val(1)
      form.unbind('submit')
      form.submit()
    $('#modal_close').text('Just save report with modified address')
    $('#modal_close').click (e) ->
      form.unbind('submit')
      form.submit()
    $('#modal').modal('show')

  $('.dt-form').submit (e) ->
    form = $(this)
    if window.clients_cache
      client = $('#destructive_client_name').val()
      result = $.grep window.clients_cache, (e) ->
        return e.title == client
      if result.length > 0
        found = result[0]
        if found.notes.replace(/\r/g, '') != $('#destructive_client_address').val()
          show_address_changed(form, found, $('#destructive_client_address').val())
          e.preventDefault()
        else
          check_client form, e
      else
        check_client form, e
    else
      check_client form, e


  #$('form[data-checkclient="true"]').submit (e) ->
  #  check_client $(this), e
#
#
  #check_client = (form, e) ->
  #  e.preventDefault()
  #  query = $('.report-form .client-input').first().val()
  #  unless query == undefined
  #    $.get('/client_suggestions?query='+encodeURIComponent(query), (data) ->
  #        if data == true
  #          form.unbind('submit')
  #          form.submit()
  #        else
  #          show_suggestions(form, data, query)
  #          e.preventDefault()
  #      )
