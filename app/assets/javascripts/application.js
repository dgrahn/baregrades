//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require_tree .


$(document).ready(function() {
	/* -- Grade scale expand button -- */
	var minorGrades = $(".scale .plus, .scale .minus");
	var gradeButton = $(".scale .button");
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
	$('#assignment_due_date').datepicker();
	//$('#assignment_due_date').datepicker( "option", "dateFormat", "mm/dd/yy" );
});