# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	tinyMCE.init
		mode: 'specific_textareas'
		editor_selector: 'tinymce'
		theme: 'advanced'
		theme_advanced_toolbar_location: 'top'
		theme_advanced_toolbar_align: 'left'
		theme_advanced_blockformats: "p, h2"
		theme_advanced_buttons1: "bold,italic,underline,separator,justifyleft,justifycenter,justifyright,justifyfull,separator,formatselect,separator,bullist,numlist,separator,undo,redo,separator,uploadimage"
		theme_advanced_buttons2: ""
		theme_advanced_buttons3: ""
		skin: "o2k7"
		skin_variant: "silver"
		convert_urls: false
		width: 548
		plugins: 'uploadimage,inlinepopups'
		pagebreak_separator: '<hr/>'
		content_css: "/screen.css"

	$('i,span[rel=tooltip]').tooltip()

	$('input, textarea').placeholder()

