//= require jquery
//= require jquery_ujs
//= require_tree .


$(document).ready(function() {
	$('#content > .dropdown').hide();
	
	$('nav a.dropdown').click(function() {
		$('#content > .dropdown').slideToggle();
	});
});
