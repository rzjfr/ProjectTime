SCHEDULER.every("1h") do
  Milestone.all.each do |milestone|
    first_id = Project.find(milestone.project_id).first_milestone.id
    current_id = Project.find(milestone.project_id).current_milestone.id
    if milestone.passed? && (milestone.id != first_id)
      if !milestone.task.empty?
        puts "All tasks for " + milestone.full_title + " assigned to "
        Task.where(milestone_id: milestone.id, state: "Backlog").update_all(milestone_id: first_id)
        Task.where(milestone_id: milestone.id, state: "Progress").update_all(milestone_id: current_id)
        Task.where(milestone_id: milestone.id, state: "Done").update_all(milestone_id: current_id)
      end
    end
  end
end
