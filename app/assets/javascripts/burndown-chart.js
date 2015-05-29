function makeBurndownChart(timeData, idealData, projectStart, projectName) {
  $(function () {
      $('#burndownChart').highcharts({
          burndownChart: {
              type: 'area',
              spacingBottom: 30
          },
          title: {
              text: 'Burndown Chart*'
          },
          subtitle: {
              text: '* sum of Archived tasks each day',
              floating: true,
              align: 'right',
              verticalAlign: 'bottom',
              y: 15
          },
          xAxis: {
                tickInterval: 24 * 3600 * 1000, // one day
                  tickWidth: 0,
                  gridLineWidth: 1,
                  labels: {
                      align: 'left',
                      x: 3,
                      y: -3
                  },
                  type: 'datetime',
          },
          yAxis: {
              title: {
                  text: 'points (estimate sum)'
              },
              labels: {
                  formatter: function () {
                      return this.value;
                  }
              }
          },
          tooltip: {
            valueSuffix: ' points',
            formatter: function () {
              if(this.series.name == projectName ){
                  return '<b>' + this.series.name + '</b><br/>' + new Date(this.x) + ': <b>' + this.y + '</b>';
              } else return false ;
            }
          },
          plotOptions: {
              series: { marker: { enabled: false } },
              area: {
                  //cursor: 'pointer',
                  fillOpacity: 0.5
              }
          },
          credits: {
              enabled: false
          },
          series: [{
                type: 'area',
                name: 'Ideal line',
                pointInterval: 24 * 3600 * 1000,
                marker: { radius: 0, fillColor: 'transparent', lineColor: 'transparent' },
                states: { hover: false},
                pointStart: projectStart,
                data: idealData
              },{
                type: 'area',
                name: projectName,
                pointInterval: 24 * 3600 * 1000,
                marker: { enabled: true, radius: 5 },
                pointStart: projectStart,
                data: timeData
              }]
      });
  });
}
