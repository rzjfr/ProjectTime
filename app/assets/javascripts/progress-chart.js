function makeProgressChart(timeData, milestoneData, projectStart, projectName) {
  $(function () {
      $('#progressChart').highcharts({
          progressChart: {
              type: 'area',
              spacingBottom: 30
          },
          title: {
              text: 'Progress Chart*'
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

              plotBands: milestoneData
          },
          yAxis: {
              title: {
                  text: 'Points (estimate sum)'
              },
              labels: {
                  formatter: function () {
                      return this.value;
                  }
              }
          },
          tooltip: {
              formatter: function () {
                  return '<b>' + this.series.name + '</b><br/>' +
                      new Date(this.x) + ': <b>' + this.y + '</b>';
              }
          },
          plotOptions: {
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
              name: projectName,
              pointInterval: 24 * 3600 * 1000,
              pointStart: projectStart,
              //data: <%#= @project.task.group_by_day(:updated_at, range: @project.start_time.midnight..Time.now).count.values %>
              //data: <%#= cumulative_sum count_state(@project, 'Archived')%>
              data: timeData
          }]
      });
  });
}
