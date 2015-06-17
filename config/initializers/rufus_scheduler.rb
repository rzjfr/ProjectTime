SCHEDULER.every("12h") do
  Project.all.each do |project|
    next if !project.uses_milestones?
    project.milestone.each do |milestone|
      first_id = project.first_milestone.id
      current_id = project.current_milestone.id
      if milestone.passed? && (milestone.id != first_id)
        if !milestone.task.empty?
            puts "All tasks for " + milestone.full_title + " assigned to "
            Task.where(milestone_id: milestone.id,
                       state: "Backlog").update_all(milestone_id: current_id)
            Task.where(milestone_id: milestone.id, state:
                       "Progress").update_all(milestone_id: current_id)
            Task.where(milestone_id: milestone.id,
                       state: "Done").update_all(state: "Archived")
        end
      end
    end
  end
end
