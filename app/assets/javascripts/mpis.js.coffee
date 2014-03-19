window.remove_fields = (link) ->   # ugly, refactor this later
	$(link).prev('input[type=hidden]').val(1)
	$(link).parents('.fields').fadeOut('fast')
	
window.add_mpi_defect = (link, html) ->
	new_id = new Date().getTime()
	regexp = new RegExp("new_mpi_defect", "g")
	inserted = $(html.replace(regexp, new_id)).insertBefore($(link).parents('tr'))
	
window.add_et_defect = (link, html) ->
	new_id = new Date().getTime()
	regexp = new RegExp("new_et_defect", "g")
	inserted = $(html.replace(regexp, new_id)).insertBefore($(link).parents('tr'))

window.add_et_probe = (link, html) ->
	new_id = new Date().getTime()
	regexp = new RegExp("new_et_probe", "g")
	inserted = $(html.replace(regexp, new_id)).insertBefore($(link).parents('tr'))

window.add_ut_defect = (link, html) ->
	new_id = new Date().getTime()
	regexp = new RegExp("new_ut_defect", "g")
	inserted = $(html.replace(regexp, new_id)).insertBefore($(link).parents('tr'))

window.add_rt_defect = (link, html) ->
	new_id = new Date().getTime()
	regexp = new RegExp("new_rt_defect", "g")
	inserted = $(html.replace(regexp, new_id)).insertBefore($(link).parents('tr'))

window.add_visual_line = (link, html) ->
	new_id = new Date().getTime()
	regexp = new RegExp("new_visual_line", "g")
	inserted = $(html.replace(regexp, new_id)).insertBefore($(link).parents('tr'))
	

window.add_pt_defect = (link, html) ->
	new_id = new Date().getTime()
	regexp = new RegExp("new_pt_defect", "g")
	inserted = $(html.replace(regexp, new_id)).insertBefore($(link).parents('tr'))

window.add_ut_probe = (link, html) ->
	new_id = new Date().getTime()
	regexp = new RegExp("new_ut_probe", "g")
	inserted = $(html.replace(regexp, new_id)).insertBefore($(link).parents('tr'))

window.autocomplete_cache = {}

$(document).ready ->
	#$('#mpi_report_attributes_date_of_inspection').datepicker dateFormat: "dd.mm.yy"
	#$('#ultrasonic_report_attributes_date_of_inspection').datepicker dateFormat: "dd.mm.yy"
	#$('#radiographic_report_attributes_date_of_inspection').datepicker dateFormat: "dd.mm.yy"
	#$('#et_report_attributes_date_of_inspection').datepicker dateFormat: "dd.mm.yy"
	#$('#et_calibration_due').datepicker dateFormat: "dd.mm.yy"
	$('.date_input').datepicker dateFormat: "dd.mm.yy"
	$('body').ajaxComplete () ->
		$('.date_input').datepicker dateFormat: "dd.mm.yy"
		$('input, textarea').placeholder()

	$('#toggle_email_form').click () ->
		$('#email_form').slideToggle('fast')
	
	$('input[data-autocomplete]').autocomplete minLength: 4, source: (request, responce) ->
		elem = $(this.element)
		model = elem.attr('data-autocomplete')
		field = elem.attr('name').match(/\[([a-z_]*)\]$/)[1]
		query = elem.val()
		if window.autocomplete_cache[model + '#' + field]?
			responce window.autocomplete_cache[model + '#' + field].filter (item) ->
				new RegExp(query, 'i').test(item)
		else
			$.get '/lookup/?model='+model+'&field='+field+'&query='+query, (data) ->
				res = data.filter (item) ->
					new RegExp(query, 'i').test(item)
				window.autocomplete_cache[model + '#' + field] = data
				responce(res)

	$('input[data-clients]').autocomplete
		minLength: 0
		source: (request, responce) ->
			elem = $(this.element)
			query = elem.val()
			if window.clients_cache?
				res = window.clients_cache.filter (item) ->
					new RegExp(query, 'i').test(item["title"])
				responce(res.map (item) ->
					item.title)
			else
				$.get('/clients_list'+'?query='+query, (data) ->
					res = data.filter (item) ->
						new RegExp(query, 'i').test(item.title)
					window.clients_cache = data
					responce(res.map (item) ->
						item.title))
		select: (a, b) ->
			$(this).val(b.item.value)
			$('#destructive_client_name').trigger('keyup')

	$('input[data-inspection-type]').autocomplete minLength: 0, source: ['General Inspection', 'Visual', 'Overlay']

	$('input[data-client-emails]').autocomplete minLength: 0, source: (request, responce) ->
		elem = $(this.element)
		id = elem.attr('data-client-emails')
		query = elem.val()
		$.get('/client_emails/'+id+'?query='+query, (data) ->
			responce(data))

	$('#show_all_clients').click () ->
		old_val = $(this).prev().val()
		$(this).prev().val('')
		$(this).prev().autocomplete "search", ""
		$(this).prev().val(old_val)
		false

	$('#show_all_emails').click () ->
		$(this).prev().autocomplete "search", ""
		false

	$('#show_all_types').click () ->
		$(this).prev().autocomplete "search", ""
		false

	$('body').click (event) ->
		if not $(event.target).closest('#show_all_clients').length
			$('#show_all_clients').prev().autocomplete "close"
		if not $(event.target).closest('#show_all_types').length
			$('#show_all_types').prev().autocomplete "close"
		if not $(event.target).closest('#show_all_emails').length
			$('#show_all_emails').prev().autocomplete "close"