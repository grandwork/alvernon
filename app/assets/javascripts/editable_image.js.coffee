jQuery ->

  $('body').on 'click', '.upload_image', (e) ->
    el = $(this).closest('.method').find('.image_row input').attr('id')
    $.get('/editable_images/new?element=' + el)
    e.preventDefault()

  $('body').on 'click', '.remove_image', (e) ->
    src = $(this).closest('tr').find('img').first().attr('src')
    input = $(this).closest('.method').find('.image_row input')
    pattern = /\/image\/(\d*)\/cropped/
    id = pattern.exec(src)[1]
    new_value = input.val().replace(id, '')
    input.val(new_value)
    $(this).closest('tr').hide()
    e.preventDefault()