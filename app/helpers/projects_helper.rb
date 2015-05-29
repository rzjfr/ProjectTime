module ProjectsHelper

  def fibonaci(n)
    # from https://gist.github.com/1007228
    (0..n).inject([1,0]) { |(a,b), _| [b, a+b] }[0]
  end

  def int_epoch(date)
    ((date.to_date.to_time.to_i + 4.5 * 3600)* 1000).floor
  end

  def start_date(project)
    int_epoch project.first_milestone.created_at
  end

  def cumulative_sum(array)
    sum = 0
    array.map{|x| sum += x}
  end

  def count_state(project, state)
    project.task.where(state: state).group_by_day(:updated_at,
                                                  range: project.start_time.midnight..Time.now).count.values
  end

  def sum_points_state(project, state)
    project.task.where(state: state).group_by_day(:updated_at,
                                                  range: project.start_time.midnight..Time.now).sum(:estimate).values
  end

  def random_color
    ((0..2).map {|i| (rand*200).floor }).join(",")
  end

  def milestone_highlight(project)
    miles = project.milestone.pluck(:end_date)
    miles = miles[0..-2].zip miles[1..-1]
    return (miles.map {|x| "{from: #{int_epoch x[0]}, to: #{int_epoch x[1]},color: \'rgba(#{random_color}, .2)\'}"}).join(",")
  end

  def range_from(from, size, to=0)
    (1..size).map {|i| from - (i*(from/size.to_f))}
  end

  def current_milestone_burndown(project)
    comming = project.current_milestone_end_date.to_time
    current = project.current_milestone_start_date.to_time
    point = project.task.where(milestone_id: project.current_milestone.id).pluck(:estimate).reject!(&:nil?)
    point = point.nil? ? 0 : point.sum
    points = project.task.where(state: 'Archived').group_by_day(:updated_at, range: current..comming).sum(:estimate).values
    till_now = (Date.tomorrow - current.to_date).to_i
    points = cumulative_sum points
    points = points.map {|x| point - x}
    return points[0..till_now]#.concat points[(till_now+1)..-1].map {|x| 0})
  end

  def ideal_milestone_burndown(project)
    comming = project.current_milestone_end_date
    current = project.current_milestone_start_date
    size = (comming - current).to_i
    point = project.task.where(milestone_id: project.current_milestone.id).pluck(:estimate).reject!(&:nil?)
    point = point.nil? ? 0 : point.sum
    return range_from(point, size)
  end

end
