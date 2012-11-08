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

	$('#assignment_due_date').datepicker({dateFormat: "yy-mm-dd"});
	
	$("input[rel*=popover]").popover({'trigger':'focus'});
	$("textarea[rel*=popover]").popover({'trigger':'focus'});
	$("select[rel*=popover]").popover({'trigger':'focus'});
});