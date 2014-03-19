$ ->
  $('body').on 'paste', '[data-pastie]', (e) ->
    el = $(this)
    $(this).val('')
    setTimeout () ->
      pasted = el.val()
      elements = el.closest('tr').find('[data-pastie]')
      parts = pasted.replace /\t/g, ' '
      parts = parts.replace /\s*$/, ''
      parts = parts.split ' '
      if parts.length > 1
        for i in [0...parts.length]
          break if i >= elements.length
          $(elements[i]).val(parts[i])
      else
        el.val(pasted)
    , 100


 
  