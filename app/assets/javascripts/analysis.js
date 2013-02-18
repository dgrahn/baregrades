function Chart(url) {
	this.load(url);

	this.options = {
		title: '',
		hAxis: {title: ''},
		vAxis: {title: ''},
		width: 500,
		height: 500,
	};
}

Chart.prototype.load = function(url) {
	jsonData = $.ajax({
			url: url,
			dataType: "json",
			async: false
		}).responseText;

	this.data = new google.visualization.DataTable(jsonData);
}

Chart.prototype.setHTitle = function(title) {
	this.options.hAxis.title = title;
}

Chart.prototype.setVTitle = function(title) {
	this.options.vAxis.title = title;
}

Chart.prototype.setTitle = function(title) {
	this.options.title = title;
}

Chart.prototype.setType = function(type) {
	this.type = type;
}

Chart.prototype.draw = function(id) {
	if(this.type == "column") {
		this.drawColumn(id);
	} else if(this.type == "line") {
		this.drawLine(id);
	}
}

Chart.prototype.drawColumn = function(id) {
	var element = document.getElementById(id);
	this.chart = new google.visualization.ColumnChart(element);
	this.chart.draw(this.data, this.options);
}

Chart.prototype.drawLine = function(id) {
	var element = document.getElementById(id);
	this.chart = new google.visualization.LineChart(element);
	this.chart.draw(this.data, this.options);
}