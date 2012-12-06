/*
 *= require jquery
 *= require jquery_ujs
 *= require jquery.ui.all
 *= require_tree .
 *= require bootstrap
 */

$(document).ready(function() {
	/* -- Grade scale expand button -- */
	var minorGrades = $(".scale .plus, .scale .minus");
	var gradeButton = $(".scale .btn");
	minorGrades.hide();

	gradeButton.click(function() {
		if(minorGrades.is(":visible")) {
			minorGrades.slideUp();
			$(this).html('+');
		} else {
			minorGrades.slideDown();
			$(this).html('-');
		}
	});

	$('.datepicker').datepicker({dateFormat: "yy-mm-dd"});
	
	$("input[rel*=popover]").popover({'trigger':'focus'});
	$("textarea[rel*=popover]").popover({'trigger':'focus'});
	$("select[rel*=popover]").popover({'trigger':'focus'});
	
	
	$(".question .expand").hide();
	$(".question button").click(function() {
		value = $(this).html();
		
		if(value == "No") {
			$(this).parent().parent().children(".expand").slideUp();
			$(this).siblings('input').attr('value', false);
		} else {
			$(this).parent().parent().children(".expand").slideDown();
			$(this).siblings('input').attr('value', true);
		}
	});
});